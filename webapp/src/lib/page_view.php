<?php

/**
* PageView - view for the pages
*
* @uses     WebAppView
*
* @category Library
* @package  Package
* @author   Raghu
*/
class PageView extends WebAppView
{

    private $_widgetLoader;
    private $_headerFooterValues = array(
        "headers" => "",
        "footers" => ""
    );

    /**
     * __construct
     * 
     * @access public
     *
     * @return mixed Value.
     */
    function __construct()
    {
        if (!$this->template_dir) {
            $app = EagleEyeWebApp::getInstance();
            $this->template_dir = $app->get('TEMPLATE_DIR');
        }
        parent::__construct();
    }

    /**
     * render - renders the mustache template
     * 
     * @param String $template Description.
     * @param Array  &$vars    mustache key value pairs
     *
     * @access public
     *
     * @return null.
     */
    public function render($template, &$vars = null)
    {
        if (!$vars) {
            $vars = array();
        }

        $this->setTemplateFromFile($template);

        $widgetVars = $this->_getWidgetVars();

        $renderVars = array_merge(
            $widgetVars,
            $this->_headerFooterValues,
            $vars
        );

        return parent::render($template, $renderVars);
    }

    /**
     * addHeader - adds the html content to the header
     * 
     * @param String $html HTML content.
     *
     * @access public
     *
     * @return null.
     */
    public function addHeader($html)
    {
        $this->_headerFooterValues['headers'] .= 
            empty($this->_headerFooterValues['headers']) ?
            $html :
            "\n" . $html;
    }

    /**
     * addFooter adds the html content to the footer
     * 
     * @param String $html HTML content.
     *
     * @access public
     *
     * @return null.
     */
    public function addFooter($html)
    {
        $this->_headerFooterValues['footers'] .= 
            empty($this->_headerFooterValues['footers']) ?
            $html :
            "\n" . $html;
    }

    /**
     * addHeaderCSS - adds the css file to the header
     * 
     * @param mixed $cssFileName css file name.
     * @param mixed $dir_level   directory name of the css file.
     *
     * @access public
     *
     * @return null.
     */
    public function addHeaderCSS($cssFileName, $dir_level = null)
    {
        $resourceLoader = ResourceLoader::getInstance($this->app);

        $cssLink = $resourceLoader->getCSS($cssFileName, $dir_level);
        if ($cssLink) {
            $this->addHeader($cssLink);
        }
    }

    /**
     * addFooterJS - adds the js file to the footer
     * 
     * @param mixed $jsFileName js file name.
     * @param mixed $dir_level  directory name of the js file
     *
     * @access public
     *
     * @return null.
     */
    public function addFooterJS($jsFileName, $dir_level = null)
    {
        $resourceLoader = ResourceLoader::getInstance($this->app);

        $jsScript = $resourceLoader->getJS($jsFileName, $dir_level);
        if ($jsScript) {
            $this->addFooter($jsScript);
        }
    }

    /**
     * _getWidgetVars - gets the variables from the widget loader to render the widgets
     * 
     * @access private
     *
     * @return Array.
     */
    private function _getWidgetVars()
    {
        if (!$this->_widgetLoader) {
            $this->_widgetLoader = WebAppWidgetLoader::getInstance();
        }

        return $this->_widgetLoader->getWidgetVars(
            $this->template, 
            $this
        );
    }
}