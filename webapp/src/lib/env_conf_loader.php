<?php
/**
* EnvironmentConfLoader - Loads the configuration file based on the environment
*
* @uses     
*
* @category Category
* @package  Package
* @author   Raghu
*/
class EnvironmentConfLoader
{

    private $_confReader;

    private $_environment_conf_dir;

    private $_base_config;

    private $_default_config;

    /**
     * setConfReader
     * 
     * @param mixed &$confReader Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setConfReader(&$confReader)
    {
        if ($confReader) {
            $this->_confReader = $confReader;
        } else {
            throw new ErrorException("Configuration Reader cannot be null");
        }
    }

    /**
     * configure - sets the configuration values to the app object, by reading the 
     * values from the base and environment confuration files
     * 
     * @param mixed $app              Description.
     * @param mixed $environment_conf Description.
     *
     * @access public
     *
     * @return null.
     */
    public function configure($app, $environment_conf = null)
    {
        if (empty($this->_confReader)) {
            throw new ErrorException("Configuration Reader is not set");
        }

        //set base_conf for all environments
        if ($this->_base_config) {
            $base_config_file = $this->_environment_conf_dir . $this->_base_config . '.json';
            $this->_confReader->addConfigFile($base_config_file);
        }

        $envConfFile = $this->_environment_conf_dir . $environment_conf .'.json';

        if ($environment_conf && file_exists($envConfFile)) {
            $this->_confReader->addConfigFile($envConfFile);
        } else if ($this->_default_config) {
            //load default config file
            $this->_confReader->addConfigFile($this->_environment_conf_dir . $this->_default_config . '.json');
        }       

        $this->_confReader->configure($app);
    }

    /**
     * setEnvironmentConfDir - sets the directory of the environment config files
     * 
     * @param mixed $dir Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setEnvironmentConfDir($dir)
    {
        if (substr($dir, -1) != "/") {
            $dir .= "/";
        }
        $this->_environment_conf_dir = $dir;
    }

    /**
     * setDefaultConfig - sets the default config file
     * 
     * @param mixed $config Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setDefaultConfig($config)
    {
        $this->_default_config = $config;
    }

    /**
     * setBaseConfig - sets the base config file
     * 
     * @param mixed $config Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function setBaseConfig($config)
    {
        $this->_base_config = $config;
    }
}