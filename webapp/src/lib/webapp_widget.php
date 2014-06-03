<?php

/**
* WebAppWidget
*
* @uses     
*
* @category Library
* @package  Package
* @author   Raghu
*/
class WebAppWidget
{

    protected $app;
    protected $args;
    protected $widgetView;
    protected $serviceAppModel;

    /**
     * __construct
     * 
     * @param mixed &$app  Description.
     * @param mixed &$args Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    function __construct(&$app, &$args = null)
    {
        if (empty($app)) {
            throw new ErrorException("Application cannot be null");
        }
        $this->app = $app; 

        $this->args = $args;

        $this->widgetView = new WidgetView($app);
    }

    
    /**
     * setWidgetView - This is used only for testing purpose.
     * 
     * @param mixed &$view Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setWidgetView(&$view)
    {
        $this->widgetView = $view;
    }

    /**
     * setServiceAppModel
     * 
     * @param mixed &$model Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setServiceAppModel(&$model)
    {
        $this->serviceAppModel = $model;
    }
}