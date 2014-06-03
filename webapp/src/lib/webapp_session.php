<?php 

/**
* WebAppSession
*
* @uses     
*
* @category Category
* @package  Package
* @author   Abhi
*/
class WebAppSession
{

    /**
     * init
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function init()
    {
        $app = EagleEyeWebApp::getInstance();
        session_name($app->get('SESSION_NAME'));
        session_start();
    }

    /**
     * set
     * 
     * @param mixed $name Description.
     * @param mixed $val  Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function set($name,$val)
    {
        $_SESSION[$name] = $val;
    }

    /**
     * delete - clears the respective session variable if the variable name is provided
     * else clears entire session variables
     * 
     * @param mixed $name Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function delete($name = null)
    {
        if ($name) {
            $_SESSION[$name] = null;
        } else {
            if (!isset($_SESSION)) {
                $this->init();
            }

            session_destroy();
            $_SESSION = array();
        }
    }

    /**
     * get
     * 
     * @param mixed $name Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function get($name)
    {
        return isset($_SESSION[$name])?$_SESSION[$name]:null;
    }
}