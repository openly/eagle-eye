<?php 

/**
* WebAppWidgetLoader - loads the widget content to the view
*
* @uses     
*
* @category Library
* @package  Package
* @author   Raghu
*/
class WebAppWidgetLoader
{

    private $_app;
    
    //To Do: $widgetLoader has been made as public variable for testing purpose only. Is this the right way?
    public static $widgetLoader = null;

    /**
     * __construct
     * 
     * @access private
     *
     * @return mixed Value.
     */
    private function __construct()
    {
        $this->_app = EagleEyeWebApp::getInstance();
    }

    /**
     * getInstance
     * 
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function getInstance()
    {
        if (!self::$widgetLoader) {
            self::$widgetLoader = new WebAppWidgetLoader();
        }

        return self::$widgetLoader;
    }

    /**
     * getWidgetVars - renders all the widgets provided in the template and returns an array of HTML 
     * 
     * @param mixed $template Description.
     * @param mixed &$view    Description.
     *
     * @access public
     *
     * @return Array.
     */
    public function getWidgetVars($template, &$view)
    {
        if (!$view) {
            throw new ErrorException("View cannot be null");
        }

        $widgets = array();
        $widgetVars = array();
        preg_match_all("/\{\{\{widget__.*\}\}\}/", $template, $widgets);
        if (!empty($widgets[0])) {
            foreach ($widgets[0] as $widgetStr) {
                $widgetStr = trim($widgetStr, '{}');
                $widgetVars[$widgetStr] = $this->_renderWidget($widgetStr, $view);
            }           
        }
        return $widgetVars;
    }

    /**
     * _renderWidget - renders the widget
     * 
     * @param mixed $widgetStr Description.
     * @param mixed &$view     Description.
     *
     * @access private
     *
     * @return String.
     */
    private function _renderWidget($widgetStr, &$view)
    {
        $widget = $this->getWidgetObject($widgetStr);
        try{
            return $widget->render($view);
        }catch(Exception $e){
            throw new ErrorException("Error happened while rendering the widget $widgetStr :: {$e->getMessage()}");
        }
    }

    /**
     * getWidgetObject - gets the widget object from the widget string
     * 
     * @param mixed $widgetString Description.
     *
     * @access public
     *
     * @return Object.
     */
    public function getWidgetObject($widgetString)
    {
        if (empty($widgetString)) {
            throw new ErrorException("Widget cannot be null");
        }

        //HTML Mustache Widget should start with 'widget'
        if (stripos($widgetString, "widget", 0) != 0) {
            throw new ErrorException("{$widgetString} not a valid widget");
        }

        //Splitting the widget string to get the widget name and args
        $wdgtStrArr = explode("__", $widgetString);
        if (count($wdgtStrArr) <= 1 || empty($wdgtStrArr[1])) {
            throw new ErrorException("{$widgetString} not a valid widget");
        }

        //class name of the widget
        $wdgtClassName = preg_replace_callback(
            '/_([a-z])/', 
            function ($match) { 
                return strtoupper($match[1]);
            }, 
            $wdgtStrArr[1]
        );
        $wdgtClassName = ucfirst($wdgtClassName) . 'Widget';

        //args for the widget class
        $wdgtParams = array_slice($wdgtStrArr, 2);
        try{
            if (class_exists($wdgtClassName, true)) {
                return new $wdgtClassName($this->_app, $wdgtParams);
            } else {
                throw new ErrorException(
                    "'$wdgtClassName' class not found"
                );
            }
        }catch(Exception $e){
            throw new ErrorException("Error happened while initializing the widget $wdgtClassName :: {$e->getMessage()}");
        }
    }
}
