<?php 

/**
* WebAppAuthTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class WebAppAuthTest extends PHPUnit_Framework_TestCase
{
    
    protected function setUp()
    {
        @session_start();

        EagleEyeWebApp::$singletonApp = new MockObject;
        $this->_app = EagleEyeWebApp::getInstance();

        $this->_serviceAppModel = new MockObject(
            array(
                "login" => true,
                "getLoggedInUserToken" => "testToken",
                "getLoggedInUserDetail" => array(
                    "first_name" => "testFirstName",
                    "last_name" => "testLastName",
                    "email" => "test@test.co",
                    "roles" => array("testRole")
                ),
                "getLoggedInUsersAccountManager" => array("AccManager"),
                "getLoggedInUsersCustomer" => array("Customer"),
                "logout" => true
            )
        );

        $this->_failServiceAppModel = new MockObject(
            array("login" => false, "logout" => false)
        );
    }

    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
        WebAppSession::delete('access_token');
        WebAppSession::delete('full_name');
        WebAppSession::delete('email');
        WebAppSession::delete('roles');
        WebAppSession::delete('customer');
        WebAppSession::delete('accountManager');
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null.
     */
    public function testEmptyInit()
    {
        $obj = new WebAppAuth();
        $nullWebApp = null;
        $obj->init($nullWebApp);    
    }

    public function testInit()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        $this->assertTrue(true);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage WebAppAuth is not initialized
     */
    public function testLoginBeforeInit()
    {
        $obj = new WebAppAuth();
        $obj->login("testUser", "testPwd");
    }

    public function testFailLogin()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_failServiceAppModel;

        $res = $obj->login("invalidUser", "invalidPwd");

        $this->assertTrue($this->_failServiceAppModel->methodCalled("login"));
        $this->assertFalse($res);
    }

    public function testLogin()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_serviceAppModel;

        $res = $obj->login("testUser", "testPwd");

        $this->assertTrue($this->_serviceAppModel->methodCalled("login"));
        $this->assertFalse($res);
        $this->assertTrue($this->_app->methodCalled('redirect', '/'));
        $this->assertEquals('testToken', $obj->getAccessToken());
    }

    public function testIsLoggedIn()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_serviceAppModel;

        $this->assertFalse($obj->isLoggedIn());

        $obj->login("testUser", "testPwd");

        $this->assertTrue($obj->isLoggedIn());
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage WebAppAuth is not initialized
     */
    public function testLogoutBeforeInit()
    {
        $obj = new WebAppAuth();

        $obj->logout();
    }

    public function testLogoutBeforeLogin()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_serviceAppModel;

        $obj->logout();

        $this->assertFalse($this->_serviceAppModel->methodCalled("logout"));
        $this->assertTrue($this->_app->methodCalled('redirect', '/login'), "App redirect");
    }

    public function testFailLogout()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_serviceAppModel;

        $obj->login("testUser", "testPwd");

        $obj->serviceAppModel = $this->_failServiceAppModel;

        $res = $obj->logout();

        $this->assertTrue($this->_failServiceAppModel->methodCalled("logout"));
        $this->assertTrue($this->_app->methodCalled('redirect', '/login'), "App redirect");
        $this->assertNULL($res);
    }

    public function testLogout()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_serviceAppModel;

        $res = $obj->login("testUser", "testPwd");

        $res = $obj->logout();

        $this->assertTrue($this->_serviceAppModel->methodCalled("logout"), "Service App model");
        $this->assertTrue($this->_app->methodCalled('redirect', '/login'), "App redirect");
        $this->assertNULL($obj->getAccessToken());
    }

    public function testHasRole()
    {
        $obj = new WebAppAuth();
        $obj->init($this->_app);
        
        $obj->serviceAppModel = $this->_serviceAppModel;

        $obj->login("testUser", "testPwd");

        $this->assertFalse($obj->hasRole("InvalidTestRole"));
        $this->assertTrue($obj->hasRole("testRole"));
    }

    public function testIsAuthorised()
    {
        $this->markTestIncomplete("Unable to test due to the Anonymous functions");
    }
}