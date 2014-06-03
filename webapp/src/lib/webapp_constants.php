<?php

/**
* WebAppConstants - class to get the various constants across the web app
*
* @uses     
*
* @category Category
* @package  Package
* @author   Raghu
*/
class WebAppConstants
{
    public static $singleTonClass = null;

    private $_staticFields = array();

    /**
     * __construct - private constructor for the singleton behavior
     * 
     * @access private
     *
     * @return null.
     */
    private function __construct()
    {
        $this->serviceAppModel = new ServiceAppConstants(EagleEyeWebApp::getInstance());
    }

    /**
     * getInstance- gets the singleton instance of the class
     * 
     * @access public
     * @static
     *
     * @return Object.
     */
    public static function getInstance()
    {
        if (self::$singleTonClass === null) {
            self::$singleTonClass = new WebAppConstants();
        }
        return self::$singleTonClass;
    }

    /**
     * getStaticFields - gets the static fields from the ServiceApp
     * 
     * @param mixed $fieldName Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _getStaticFields($fieldName)
    {
        $res = $this->serviceAppModel->get($fieldName);
        return $res ? $res : array();
    }

    /**
     * getServerSizes - returns the available server sizes from the ServiceApp
     * 
     * @access public
     *
     * @return Array.
     */
    public function getServerSizes()
    {
        if (empty($this->_staticFields['server_sizes'])) {
            $this->_staticFields['server_sizes'] = $this->_getStaticFields('server-sizes');
            $this->_staticFields['server_sizes'] = $this->_staticFields['server_sizes']['server_size'];
        }

        return empty($this->_staticFields['server_sizes']) ?
            array() : $this->_staticFields['server_sizes'];
    }

    /**
     * getServerClasses - list all the server classes
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getServerClasses()
    {
        if (empty($this->_staticFields['class'])) {
            $this->_staticFields['class'] = $this->_getStaticFields('server-class');
            $this->_staticFields['class'] = $this->_staticFields['class']['server_class'];
        }

        return empty($this->_staticFields['class']) ?
            array() : $this->_staticFields['class'];
    }

    /**
     * getServerLocations - returns the available server locations from the ServiceApp
     * 
     * @access public
     *
     * @return Array.
     */
    public function getServerLocations()
    {
        if (empty($this->_staticFields['server_step2_fields'])) {
            $this->_staticFields['server_step2_fields'] = $this->_getStaticFields('server-locations');
        }
        return empty($this->_staticFields['server_step2_fields']['location']) ?
            array() : $this->_staticFields['server_step2_fields']['location'];
    }

    /**
     * getServerLocations - returns the available server locations from the ServiceApp
     * 
     * @access public
     *
     * @return Array.
     */
    public function getServerOS()
    {
        if (empty($this->_staticFields['server_step2_fields'])) {
            $this->_staticFields['server_step2_fields'] = $this->_getStaticFields('server-locations');
        }
        return empty($this->_staticFields['server_step2_fields']['operating_system']) ?
            array() : $this->_staticFields['server_step2_fields']['operating_system'];
    }

    /**
     * getServerLocations - returns the available server locations from the ServiceApp
     * 
     * @access public
     *
     * @return Array.
     */
    public function getServerNetworks()
    {
        if (empty($this->_staticFields['server_step2_fields'])) {
            $this->_staticFields['server_step2_fields'] = $this->_getStaticFields('server-locations');
        }

        return empty($this->_staticFields['server_step2_fields']['network']) ?
            array() : $this->_staticFields['server_step2_fields']['network'];
    }

    /**
     * getServerCost
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getServerCost()
    {
        if (empty($this->_staticFields['server_cost'])) {
            $server_cost = $this->_getStaticFields('server-cost');

            //convert all to lowercase for the inconsistent bad API
            $lowCaseServerCost = array();
            foreach($server_cost as $key => &$value) {
                $lowCaseServerCost[strtolower($key)] = array_change_key_case($value);
            }

            $this->_staticFields['server_cost'] = $lowCaseServerCost;
        }

        return empty($this->_staticFields['server_cost']) ?
            array() : $this->_staticFields['server_cost'];
    }
}