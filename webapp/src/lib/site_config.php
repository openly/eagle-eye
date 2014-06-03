<?php

/**
* SiteConfig
*
* @uses     
*
* @category Category
* @package  Package
* @author   Raghu
* @license  
* @link     
*/
class SiteConfig
{
    private $_envLoader = null;

    /**
     * __construct
     * 
     * @access public
     *
     * @return mixed Value.
     */
    function __construct()
    {
        $this->_envLoader = new EnvironmentConfLoader();
        
        $this->_envLoader->setConfReader(new ConfReader());
        $this->_envLoader->setEnvironmentConfDir(__DIR__ . "/../../conf/environment");
        $this->_envLoader->setBaseConfig("base_conf");
        $this->_envLoader->setDefaultConfig("localhost");
    }

    /**
     * configure
     * 
     * @param mixed $conf Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function configure($conf = null)
    {
        $this->_envLoader->configure($this, $conf);
    }

    /**
     * set
     * 
     * @param mixed $key   Description.
     * @param mixed $value Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function set($key, $value)
    {
        $this->{$key} = $value;
    }

    /**
     * get
     * 
     * @param mixed $key Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function get($key)
    {
        return property_exists($this, $key) ? $this->{$key} : null;
    }
}