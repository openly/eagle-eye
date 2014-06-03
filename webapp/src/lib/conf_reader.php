<?php

/**
* Reads the configurable settings from the json file and sets it to the webapp
*
* @uses     
*
* @category Library
* @package  WebApp
* @author   Raghu
*/
class ConfReader
{
    /**
     * $_confFiles - holds the path of the json file which needs to be configured to the app
     *
     * @var mixed
     *
     * @access private
     */
    private $_confFiles = array();

    /**
     * $_app - application object to which needs to be configured
     *
     * @var mixed
     *
     * @access private
     */
    private $_app;

    /**
     * __construct - checks and sets the arguments, if not valid throws respective ErrorExceptions
     * 
     * @param mixed $file - path of the json file which needs to be configured to the app
     *
     * @access public
     *
     * @return ConfReader Object.
     */
    function __construct($file = null)
    {
        if ($file) {
            $this->addConfigFile($file);
        }
    }

    /**
     * addConfigFile
     * 
     * @param mixed $file Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function addConfigFile($file)
    {
        if (!file_exists($file)) {
            throw new ErrorException("'$file' file not found");
        }

        $this->_confFiles[] = $file;
    }

    /**
     * configure - sets all the values in the configure file to the application
     * 
     * @param mixed $app Description.
     *
     * @access public
     *
     * @return Boolean True on Success else throws ErrorException.
     */
    public function configure($app)
    {
        if (!$app) {
            throw new ErrorException("Application cannot be null");
        }

        $this->_app = $app;

        $this->_setDefaultConf();

        foreach ($this->_confFiles as $file) {
            $this->_setConfFromFile($file);
        }

        return true;
    }

    /**
     * _setConfFromFile
     * 
     * @param mixed $file Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _setConfFromFile($file)
    {
        $jsonData = json_decode(file_get_contents($file), true);

        if (!$jsonData) {
            throw new ErrorException("Json in the '{$file}' cannot be decoded");
        }       

        if (is_array($jsonData)) {
            array_walk($jsonData, array($this, '_setValueInApplication'));
        }
    }

    /**
     * _setDefaultConf
     * 
     * @access private
     *
     * @return mixed Value.
     */
    private function _setDefaultConf()
    {
        $this->_app->set('APP_DIR', __DIR__ . '/../../');
    }

    /**
     * _setValueInApplication - calls the set method of the application by passing key value pair to it
     * 
     * @param mixed &$value configure value
     * @param mixed $key    respective configure key
     *
     * @access private
     *
     * @return null.
     */
    private function _setValueInApplication(&$value, $key)
    {
        $value = Substitute::fromAppConf($this->_app, $value);
        $this->_app->set($key, $value);
    }

}