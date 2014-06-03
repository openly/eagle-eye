<?php 

/**
* Initialize all the application components and hold them
*
* @uses EagleEyeConf, EagleEyeRouter, EagleEyeAuth, EagleEyeSession  
*
* @category BaseApp
* @package  App
* @author   Abhilash Hebbar
* @link     
*/
class EagleEyeWebApp
{
    /**
     * The application configuration object. Holds all the configuration.
     *
     * @var EagleEyeConf
     *
     * @access public
     */
    public $conf;

    /**
     * The router object, match the route and execute relevant controller.
     *
     * @var EagleEyeRouter
     *
     * @access public
     */
    public $router;

    /**
     * Authenciation object. Hold the authentication deatils, perform login, logout etc.
     * Also send valid tokens with all requests to serviceapp.
     *
     * @var EagleEyeAuth
     *
     * @access public
     */
    public $auth;

    /**
     * Global session container for application
     *
     * @var EagleEyeSession
     *
     * @access public
     */
    public $session;

    private $_configured = false;
    private $_routesSetup = false;
    private $_sessionInitialized = false;
    private $_authSetup = false;

    private $_framework;

    /**
     * __construct
     * 
     * @param mixed $framework Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function __construct($framework)
    {
        if ($framework) {
            $this->_framework = $framework;
        } else {
            throw new ErrorException("Framework cannot be null");
        }
    }

    //To Do: $singletonApp has been made as public variable for testing purpose only. Is this the right way?
    /**
     * $singletonApp
     *
     * @var Object
     *
     * @access public
     * @static
     */
    public static $singletonApp = null;

    /**
     * getInstance - get the singleton instance of the web app
     * 
     * @param mixed $framework Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function getInstance($framework = null)
    {
        if (!self::$singletonApp) {
            self::$singletonApp = new EagleEyeWebApp($framework);
        }
        return self::$singletonApp;
    }

    /**
     * configure - Read the app configuration
     * 
     * @param mixed $env Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function configure($env = null)
    {
        if (!$this->conf) {
            throw new ErrorException("Configure cannot be null");
        }

        $this->conf->configure($env);

        $this->_configured = true;
    }

    /**
     * Setup all the routes for the application
     * 
     * @access public
     *
     * @return Void.
     */
    public function setupRoutes()
    {
        if (!$this->router) {
            throw new ErrorException("Routes cannot be set up without a valid router object");
        }

        if (!$this->_configured) {
            $this->configure();
        }
        $this->router->setup($this, $this->_framework);
        $this->_routesSetup = true;
    }

    /**
     * Seup the Authentication
     * 
     * @access public
     *
     * @return Void.
     */
    public function setupAuth()
    {
        $this->auth->init($this);
        $this->_authSetup = true;
    }

    /**
     * Initialize the session
     * 
     * @access public
     *
     * @return Void.
     */
    public function initSession()
    {
        $this->session->init($this);
        $this->_sessionInitialized = true;
    }

    /**
     * Check if we have sufficient info to run the application
     * 
     * @access private
     *
     * @return Boolean.
     */
    private function canRun()
    {
        return $this->_configured && $this->_routesSetup;
    }

    /**
     * Run the webapp
     * 
     * @access public
     *
     * @return Void.
     */
    public function run()
    {
        if (!$this->canRun()) {
            throw new ErrorException("Cannot run application");
        }
        $framework = $this->_framework;
        $framework::start();
    }

    /**
     * gets the values sets in the appplication
     * 
     * @param mixed $key Description
     *
     * @access public
     *
     * @return mixed Value if found else null.
     */
    public function get($key)
    {
        return $this->conf->get($key);
    }

    /**
     * returns all the values set to the app
     * 
     * @access public
     *
     * @return mixed Array.
     */
    public function getAllConfiguredValues()
    {
        return get_object_vars($this->conf);
    }

    /**
     * redirect
     * 
     * @param mixed $newPath Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function redirect($newPath)
    {
        $framework = $this->_framework;
        $framework::redirect($this->conf->get('REL_DIR') . $newPath);
    }

    /**
     * headerRedirect
     * 
     * @param mixed $path Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function headerRedirect($path)
    {
        header("Location: " . $path);
        exit;
    }

    /**
     * requestPath
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function requestPath()
    {
        $framework = $this->_framework;
        $request = $framework::request();
        return  '/' . trim(str_replace($request->base, '', $request->url), '/');
    }
}