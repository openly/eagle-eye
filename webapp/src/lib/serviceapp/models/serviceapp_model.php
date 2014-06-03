<?php

/**
* ServiceAppModel
*
* @uses     
*
* @category Category
* @package  Package
* @author   Raghu
*/
abstract class ServiceAppModel
{

    protected $app;
    public $serviceAppAPI;
    protected $errors;

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
        $this->serviceAppAPI = new ServiceAppAPI($this->app);
        $this->errors = array();
    }

    /**
     * get
     * 
     * @param mixed $id Description.
     *
     * @access public
     *
     * @return Boolean Value.
     */
    abstract public function get($id);

    /**
     * save
     * 
     * @param mixed &$args Description.
     *
     * @access public
     *
     * @return Boolean Value.
     */
     abstract public function save(&$args);

    /**
     * delete
     * 
     * @param mixed $id Description.
     *
     * @access public
     *
     * @return Boolean Value.
     */
    abstract public function delete($id);

    /**
     * isServiceAppResponseContainsResult
     * 
     * @param mixed &$res Description.
     *
     * @access protected
     *
     * @return Boolean Value.
     */
    protected function isServiceAppResponseContainsResult(&$res)
    {
        return  $this->isServiceAppResponseSuccess($res) 
            && isset($res['result']);
    }

    /**
     * isServiceAppResponseSuccess
     * 
     * @param mixed &$res Description.
     *
     * @access protected
     *
     * @return Boolean Value.
     */
    protected function isServiceAppResponseSuccess(&$res)
    {
        return  !empty($res['status'])
            && $res['status'] == "success";
    }

    /**
     * isServiceAppResponseContainsError
     * 
     * @param mixed &$res Description.
     *
     * @access protected
     *
     * @return Boolean Value.
     */
    protected function isServiceAppResponseContainsError(&$res)
    {
        return !empty($res['errors']);
    }

    /**
     * parseServiceAppResult
     * 
     * @param mixed &$res Description.
     *
     * @access protected
     *
     * @return mixed Value.
     */
    protected function parseServiceAppResult(&$res)
    {
        $this->errors = array();
        if ($this->isServiceAppResponseSuccess($res)) {
            if (isset($res['id'])) {
                $this->id = $res['id'];
            }
            return $this->isServiceAppResponseContainsResult($res) ?
                $res['result'] : true;
        } else {
            if ($this->isServiceAppResponseContainsError($res)) {
                $this->errors = $res['errors'];
            }
            return false;
        }
    }

    /**
     * getErrors
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getErrors()
    {
        return $this->errors;
    }

    /**
     * getID
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getID()
    {
        return $this->id;
    }
}