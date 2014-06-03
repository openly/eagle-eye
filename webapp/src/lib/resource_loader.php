<?php 

/**
* ResourceLoader - gets the js or css scripts from the app/widget directories
*
* @uses     
*
* @category Library
* @package  Package
* @author   Raghu
*/
class ResourceLoader
{
    public static $resourceLoader;
    private $_jsTempalte = "<script type='text/javascript' src='{{jsFile}}'></script>";
    private $_cssTempalte = "<link rel='stylesheet' type='text/css' href='{{cssFile}}'>";
    private $_resources = array(
        "js" => array(),
        "css" => array()
    );

    /**
     * __construct private constructor to implment the singelton architecture
     * 
     * @param mixed &$app Description
     *
     * @access private
     *
     * @return Object.
     */
    private function __construct(&$app)
    {
        if (!$app) {
            throw new ErrorException("Application cannot be null");
        }
        $this->_app = $app;
    }

    /**
     * getInstance - gets the instance of the Singelton Resource layer
     * 
     * @param mixed &$app Service App
     *
     * @access public
     * @static
     *
     * @return Object.
     */
    public static function getInstance(&$app)
    {
        if (!self::$resourceLoader) {
            self::$resourceLoader = new ResourceLoader($app);
        }
        return self::$resourceLoader;
    }

    /**
     * _isNotDuplicateResource -checks whether the resource is already added or not
     * 
     * @param mixed  $fileName Description.
     * @param string $jsOrCss  Description.
     *
     * @access private
     *
     * @return Boolean.
     */
    private function _isNotDuplicateResource($fileName, $jsOrCss = "js")
    {
        return !in_array($fileName, $this->_resources[$jsOrCss]);
    }

    /**
     * getJS - returns the js script with the respective relative path
     * 
     * @param mixed $jsFileName Description
     * @param mixed $dir_level  (Optional, By default it will be app level) .
     *
     * @access public
     *
     * @return JS HTML script or false if resouce already added.
     */
    public function getJS($jsFileName, $dir_level = "app")
    {
        if (empty($jsFileName)) {
            throw new ErrorException("JS file name cannot be empty");
        }
        if ($this->_isNotDuplicateResource($jsFileName)) {
            //set directory level
            if ($dir_level == "widget") {
                $file_dir = $this->_app->get('WIDGET_DIR');
                $file_rel_dir = $this->_app->get('WIDGET_REL_DIR');
            } else {
                $file_dir = $this->_app->get('APP_DIR');
                $file_rel_dir = $this->_app->get('REL_DIR');
            }

            $jsFilePath = $file_dir . "/js/" .$jsFileName .".js";
            if (!file_exists($jsFilePath)) {
                throw new ErrorException("$jsFileName file not found");                         
            }

            $this->_resources['js'][] = $jsFileName;

            $jsRelFile = $file_rel_dir . "/js/" .$jsFileName .".js";
            return str_replace('{{jsFile}}', $jsRelFile, $this->_jsTempalte);
        }

        return false;
    }

     /**
     * getCSS - returns the css script with the respective relative path
     * 
     * @param mixed $cssFileName Description.
     * @param mixed $dir_level   (Optional, By default it will be app level) .
     *
     * @access public
     *
     * @return CSS HTML script or false if resouce already added.
     */
    public function getCSS($cssFileName, $dir_level = "app")
    {
        if (empty($cssFileName)) {
            throw new ErrorException("CSS file name cannot be empty");
        }
        
        if ($this->_isNotDuplicateResource($cssFileName, "css")) {
            //set directory level
            if ($dir_level == "widget") {
                $file_dir = $this->_app->get('WIDGET_DIR');
                $file_rel_dir = $this->_app->get('WIDGET_REL_DIR');
            } else {
                $file_dir = $this->_app->get('APP_DIR');
                $file_rel_dir = $this->_app->get('REL_DIR');
            }

            $cssFilePath = $file_dir . "/css/" .$cssFileName .".css";
            if (!file_exists($cssFilePath)) {
                throw new ErrorException("$cssFileName file not found");                            
            }

            $this->_resources['css'][] = $cssFileName;

            $cssRelFile = $file_rel_dir . "/css/" .$cssFileName .".css";
            return str_replace('{{cssFile}}', $cssRelFile, $this->_cssTempalte);
        }

        return false;
    }
}