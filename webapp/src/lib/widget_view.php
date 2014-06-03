<?php

/**
* WidgetView - view for the widgets
*
* @uses     WebAppView
*
* @category Library
* @package  Package
* @author   Raghu
*/
class WidgetView extends WebAppView
{

    /**
     * __construct
     * 
     * @access public
     *
     * @return mixed Value.
     */
    function __construct(&$app = null)
    {
        $this->app = empty($app) ? EagleEyeWebApp::getInstance() : $app;

        $this->template_dir = $this->app->get('WIDGET_DIR') . '/templates';
        parent::__construct($this->app);
    }
}