<?php 

/**
* WebAppRouter - routes to the url via controller and view
*
* @uses     
*
* @category Library
* @package  Package
* @author   Abhi
*/
class WebAppRouter
{

    private $_routerFile;
    private $_routes;

    /**
     * __construct
     * 
     * @param mixed $routerFile Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    function __construct($routerFile)
    {
        $this->_routerFile = $routerFile;

    }

    /**
     * setup
     * 
     * @param mixed &$app      Description.
     * @param mixed $frameWork Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setup(&$app, $frameWork)
    {
        if (!$app) {
            throw new ErrorException(
                "Application cannot be null"
            );
        }
        if (!$frameWork) {
            throw new ErrorException(
                "Framework cannot be null"
            );
        }

        $routerFile = $this->_routerFile;
        $this->_routerFile = $app->get('CONFIG_DIR') . '/' . $routerFile;
        //To Do: Is this check is valid
        if (!file_exists($this->_routerFile)) {
            throw new ErrorException(
                "'$routerFile' file not found in '" . $app->get('CONFIG_DIR') . "'"
            );
        }

        $routesConf = json_decode(file_get_contents($this->_routerFile), true);
        if (!$routesConf) {
            throw new ErrorException("Json in the '{$this->_routerFile}' cannot be decoded");
        }
        $this->_recursiveRouteSetup($app, $frameWork, $routesConf);
    }

    /**
     * _recursiveRouteSetup
     * 
     * @param mixed  $app         Description.
     * @param mixed  $frameWork   Description.
     * @param mixed  $routes      Description.
     * @param string $parentRoute Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _recursiveRouteSetup($app,$frameWork,$routes,$parentRoute='')
    {
        foreach ($routes as $route => $conf) {
            $this->_setupSingleRoute($route, $conf, $parentRoute, $app, $frameWork);
            if (isset($conf['sub_routes']) 
                && is_array($conf['sub_routes'])
            ) {
                $this->_recursiveRouteSetup($app, $frameWork, $conf['sub_routes'], $route);
            }
        }
    }

    /**
     * _setupSingleRoute
     * 
     * @param mixed $route       Description.
     * @param mixed $conf        Description.
     * @param mixed $parentRoute Description.
     * @param mixed $app         Description.
     * @param mixed $frameWork   Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _setupSingleRoute($route, $conf, $parentRoute, $app, $frameWork)
    {
        $conf = $this->_setDefaultRouteConf($conf);

        $controller = $conf['controller'];

        $method = strtoupper($conf['method']);

        $routeString = $method . ' ' . $parentRoute . $route;
        $controllerClass = ucfirst($controller . 'Controller');

        try{
            if (class_exists($controllerClass, true)) {
                $controllerObj = new $controllerClass($app);    
            } else {
                throw new ErrorException(
                    "'$controllerClass' class not found"
                );
            }           
        }catch(Exception $e){
            throw new ErrorException(
                "'$controllerClass' class doesn't exists for route $routeString : {$e->getMessage()}"
            );
        }
        
        $routeMethod = function() use ($routeString, $controllerObj, $conf) {
            $method = array($controllerObj, $conf['action']);
            if (!is_callable($method)) {
                throw new ErrorException("Method not found for route $routeString");
            }
            $args = func_get_args();
            array_pop($args);
            call_user_func_array($method, $args);
        };


        if (isset($conf['csrf_validation'])) {
            $routeMethodOld = $routeMethod;
            $routeMethod = function () use ($app, $routeMethodOld) {
                if (CSRFToken::validate($_REQUEST['CSRF_TOKEN'])) {
                    call_user_func_array($routeMethodOld, func_get_args());
                } else {
                    Flight::halt(401, 'Invalid token');
                }
            };
        }

        if (isset($conf['authorisation'])) {
            $frameWork::route(
                $routeString,
                $app->auth->isAuthroished($conf['authorisation'], $routeMethod)
            );
        } else {
            $frameWork::route($routeString, $routeMethod);
        }
    }

    /**
     * _setDefaultRouteConf
     * 
     * @param mixed $conf Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _setDefaultRouteConf($conf)
    {
        if (is_string($conf)) {
            $conf = array('controller'=>$conf);
        }

        if (!isset($conf['method'])) {
            $conf['method'] = 'GET';
        }

        if (!isset($conf['action'])) {
            $conf['action'] = 'index';
        }

        return $conf;
    }
}