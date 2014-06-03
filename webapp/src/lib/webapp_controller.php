<?php 
/**
* WebAppController
*
* @uses     
*
* @category Category
* @package  Package
* @author   Abhi
*/
class WebAppController
{
    protected $app;
    protected $path;

    protected $pageView;
    protected $serviceAppModel;

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

    /**
     * setView
     * 
     * @param mixed &$view Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setPageView(&$view)
    {
        $this->pageView = $view;
    }

    /**
     * __construct
     * 
     * @access public
     *
     * @return mixed Value.
     */
    function __construct()
    {
        $this->app = EagleEyeWebApp::getInstance();
        $this->pageView = new PageView();
    }

    private $_relativePath;

    /**
     * _getRelativePath
     * 
     * @access protected
     *
     * @return mixed Value.
     */
    protected function getRelativePath()
    {
        if ( !$this->_relativePath) {
            $this->_relativePath = $this->app->get("REL_DIR") . $this->path;
        }
        return $this->_relativePath;
    }

    /**
     * setErrorsInWebSession
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function setErrorsInWebSession()
    {
        $errors = $this->serviceAppModel->getErrors();
        if (!empty($errors)) {
            $msgs['errors'] = $errors;
            WebAppSession::set('messages', $msgs);
        }
    }

    /**
     * setDDForMustache - converts the key value pair to array of "key", "value" 
     * and "selected" starting from indices 0,1,2...
     * e.g., array("key1"=>"valu1","key2"=>"value2") as 
     * array(
     *      0 => array("key"=>"key1","value"=>"value1","selected"=>true),
     *      1 => array("key"=>"key2","value"=>"value2","selected"=>true)
     * )
     * 
     * @param mixed &$array    Description.
     * @param mixed $sel_value Description.
     *
     * @access protected
     *
     * @return mixed Value.
     */
    protected function setDDForMustache(&$array, $sel_value)
    {
        $temp = array();
        foreach ($array as $key => $value) {
            $temp[] = array(
                "key" => $key,
                "value" => $value,
                "selected" => ($key == $sel_value)
            );
        }
        return $temp;
    }

    /**
     * ajaxResponse
     * 
     * @param mixed &$res Description.
     * @param mixed $json Description.
     *
     * @access protected
     *
     * @return mixed Value.
     */
    protected function ajaxResponse(&$res, $json=true)
    {
        $result = array();
        if ($res) {
            $result = array('status' => 'success');
        } else {
            $result = array(
                'status' => 'failure',
                'errors' => $this->serviceAppModel->getErrors()
            );
        }
        return $json ? json_encode($result) : $result;
    }
}