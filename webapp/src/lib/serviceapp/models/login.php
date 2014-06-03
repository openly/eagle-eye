<?php

/**
* ServiceAppLogin
*
* @uses     
*
* @category Category
* @package  Package
* @author   Raghu 
*/
class ServiceAppLogin
{
    private $_token = null;
    private $_loggedInUser = null;
    private $_customer = null;
    private $_accountManager = null;
    private $_serviceDeliveryManager = null;

    /**
     * __construct
     * 
     * @param mixed &$app Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    function __construct(&$app)
    {
        $this->serviceAppAPI = new ServiceAppAPI($app);
    }

    /**
     * login
     * 
     * @param mixed $username Description.
     * @param mixed $password Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function login($username, $password)
    {
        $res = $this->serviceAppAPI->post(
            'login',
            array(
                'user'=>$username,
                'pass'=>$password
            )
        );

        if (!empty($res['status']) && $res['status'] == 'success') {
            $this->_token = $res['token'];
            $this->_loggedInUser = $res['user'];
            $this->_customer = $res['customer'];
            $this->_accountManager = array($res['accountManager']);
            $this->_serviceDeliveryManager = array(
                $res['serviceDeliveryManager']
            );
            return true;
        }
        
        return false;
    }

    /**
     * getLoggedInUserToken
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getLoggedInUserToken()
    {
        return $this->_token;
    }

    /**
     * getLoggedInUserDetail
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getLoggedInUserDetail()
    {
        return $this->_loggedInUser;
    }

    /**
     * getLoggedInUsersCustomer
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getLoggedInUsersCustomer()
    {
        return $this->_customer;
    }

    /**
     * getLoggedInUsersAccountManager
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getLoggedInUsersAccountManager()
    {
        return $this->_accountManager;
    }

    /**
     * getLoggedInUsersSDManager - returns Service Delivery manager
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getLoggedInUsersSDManager()
    {
        return $this->_serviceDeliveryManager;
    }

    /**
     * logout
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function logout()
    {
        $res = $this->serviceAppAPI->get('logout');

        if (!empty($res['status']) && $res['status'] == 'success') {
            $this->_token = null;
            $this->_loggedInUser = null;
            $this->_customer = null;
            $this->_accountManager = null;
            return true;
        }

        return false;
    }
}