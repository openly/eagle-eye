<?php 

/**
* ServiceAppLoginTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class ServiceAppLoginTest extends PHPUnit_Framework_TestCase
{
    
    protected function setUp()
    {
        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => array(
                    "params" => array(
                        "SERVICEAPP_URL" => "http://localhost:4444/",
                    )
                )
            )
        );
        $this->_app = EagleEyeWebApp::getInstance();
        $this->_app->auth = new MockObject;

        $this->_token = "test token";
        $this->_user = "user details";
        $this->_customer = "customer details";
        $this->_accountManager = "account manager details";
        $this->_sdManager = "service delivery manager details";

        $this->_api = new MockObject(
            array(
                "get" => array(
                    "status" => "success"
                ),
                "post" => array(
                    "status" => "success"
                    , "token" => $this->_token
                    , "user" => $this->_user
                    , "customer" => $this->_customer
                    , "accountManager" => $this->_accountManager
                    , 'serviceDeliveryManager' => $this->_sdManager
                )
            )
        );

        $this->_failApi = new MockObject(
            array(
                "get" => array(
                    "status" => "failure"
                ),
                "post" => array(
                    "status" => "failure"
                )
            )
        );

    }

    public function testFailLogin()
    {
        $model = new ServiceAppLogin($this->_app);
        $model->serviceAppAPI = $this->_failApi;
        
        $user = "testUser";
        $pass = "testPwd";
        $result = $model->login($user, $pass);

        $this->assertTrue(
            $this->_failApi->methodCalled(
                'post', 
                array('login', array('user' => $user, 'pass' => $pass)),
                "Service App Model"
            )
        );
        $this->assertFalse($result);
    }

    public function testLogin()
    {
        $model = new ServiceAppLogin($this->_app);
        $model->serviceAppAPI = $this->_api;
        
        $user = "testUser";
        $pass = "testPwd";
        $result = $model->login($user, $pass);

        $this->assertTrue(
            $this->_api->methodCalled(
                'post', 
                array('login', array('user' => $user, 'pass' => $pass)),
                "Service App Model"
            )
        );
        $this->assertTrue($result);

        $this->assertEquals($this->_token, $model->getLoggedInUserToken());
        $this->assertEquals($this->_user, $model->getLoggedInUserDetail());
        $this->assertEquals($this->_customer, $model->getLoggedInUsersCustomer());        
        $this->assertEquals(array($this->_accountManager), $model->getLoggedInUsersAccountManager());
        $this->assertEquals(array($this->_sdManager), $model->getLoggedInUsersSDManager());
    }

    public function testFailLogout()
    {
        $model = new ServiceAppLogin($this->_app);
        $model->serviceAppAPI = $this->_failApi;
        
        $result = $model->logout();
        
        $this->assertTrue($this->_failApi->methodCalled('get', "logout"));
        $this->assertFalse($result);
    }

    public function testLogout()
    {
        $model = new ServiceAppLogin($this->_app);
        $model->serviceAppAPI = $this->_api;
        
        $user = "testUser";
        $pass = "testPwd";
        $result = $model->login($user, $pass);


        $this->assertTrue($result, "Login Service App Model");

        $result = $model->logout();
        
        $this->assertTrue($result, "Logout Service App Model");
        $this->assertNULL($model->getLoggedInUserToken());
        $this->assertNULL($model->getLoggedInUserDetail());
        $this->assertNULL($model->getLoggedInUsersCustomer());        
        $this->assertNULL($model->getLoggedInUsersAccountManager());
    }
}