<?php 
/**
* WebAppView - View for the Web App
*
* @uses     
*
* @category Library
* @package  Package
* @author   Raghu
*/
class WebAppView
{

    protected $app;
    protected $template;
    protected $template_dir;
    protected $template_partials_dir; 
    protected $template_file_name;

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

        if (empty($this->template_dir)) {
            $this->template_dir = $this->app->get('TEMPLATE_DIR');
        }

        if (empty($this->template_partials_dir)) {
            $this->template_partials_dir = $this->app->get('TEMPLATE_PARTIALS_DIR');
        }
    }

    /**
     * _setTemplateFromFile
     * 
     * @param mixed $template Description.
     *
     * @access protected
     *
     * @return mixed Value.
     */
    protected function setTemplateFromFile($template)
    {
        if ($this->template_file_name != $template) {
            $templateFile = $this->template_dir. "/$template.html";
            if (!file_exists($templateFile)) {
                throw new ErrorException("Template '$template' not found (File: $templateFile)");
            } else {
                $this->template = file_get_contents($templateFile);
                $this->template_file_name = $template;
            }
        }
    }

   

    /**
     * renders with the variables passed
     * 
     * @param mixed $template Description.
     * @param mixed &$vars    array of key value pairs needs to be set in the template.
     *
     * @access public
     *
     * @return String.
     */
    public function render($template, &$vars = null)
    {
        $this->setTemplateFromFile($template);

        if (!$vars) {
            $vars = array();
        }

        $renderValues = $this->app->getAllConfiguredValues();

        //values in the 'vars' has higher priority than App Conf values 
        $renderValues = array_merge($renderValues, $vars);

        $m = new Mustache_Engine(
            array(
                'partials_loader' => new Mustache_Loader_FilesystemLoader($this->template_partials_dir)
            )
        );

        return $m->render($this->template, $renderValues);
    }   
}