<?php 

/**
* LoginControllerTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class LoginControllerTest extends PHPUnit_Framework_TestCase
{
    
    protected function setUp()
    {
        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => array(
                    "params" => array(
                        "TEMPLATE_DIR" => "test/tmp/views",
                        "REL_DIR" => "/"
                    )
                )
            )
        );
        $this->_app = EagleEyeWebApp::getInstance();

        $this->_serviceAppModel = new MockObject(
            array(
                "get" => array(1),
            )
        );
        $this->_view = new MockObject;
        $_POST = array(
            'username' => ''
            , 'password' => ''
        );
    }

    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
        $_POST = array();
    }

    public function testIndexWithoutAlreadyLoggedIn()
    {
        $cont = new LoginController();
        $cont->setPageView($this->_view);
        $this->_app->auth = new MockObject(
            array("isLoggedIn" => false)
        );
        $cont->index();

        $this->assertTrue($this->_view->methodCalled('render'), "page view render");
    }

    public function testIndexWithAlreadyLoggedIn()
    {
        $cont = new LoginController();
        $cont->setPageView($this->_view);
        $this->_app->auth = new MockObject(
            array("isLoggedIn" => true)
        );
        $cont->index();

        $this->assertFalse($this->_view->methodCalled('render'), "page view render");
        $this->assertTrue($this->_app->methodCalled('redirect'), "/dashboard");
    }

    public function testLoginWithoutUserName()
    {
        $cont = new LoginController();
        $cont->setPageView($this->_view);
        $this->_app->auth = new MockObject(
            array("isLoggedIn" => true)
        );
        $cont->doLogin();

        $expectedRenderData = array(
            'username' => $_POST['username']
        );
        $this->assertTrue(
            $this->_view->methodCalled(
                'render'
                , array(
                    'login'
                    , $expectedRenderData
                )
            )
        );
    }

    public function testFailLogin()
    {
        $this->_app->auth = new MockObject(
            array("login" => false)
        );

        $_POST = array(
            'username' => 'testuser',
            'password' => '*******'
        );

        $cont = new LoginController();
        $cont->setPageView($this->_view);

        $cont->doLogin();
        
        $this->assertTrue($this->_app->auth->methodCalled('login'));
        $this->assertTrue($this->_view->methodCalled('render'), "page view render");
    }

    public function testSuccessLogin()
    {
        $this->expectOutputString('Login successful...');

        $this->_app->auth = new MockObject(
            array("login" => true)
        );

        $_POST = array(
            'username' => 'testuser',
            'password' => '*******'
        );

        $cont = new LoginController();
        $cont->setPageView($this->_view);
        
        $cont->doLogin();
        
        $this->assertTrue($this->_app->auth->methodCalled('login'));
        $this->assertFalse($this->_view->methodCalled('render'), "page view render");
    }

    public function testLogout()
    {
        $this->_app->auth = new MockObject;

        $cont = new LoginController();
        $cont->setPageView($this->_view);
        
        $cont->logout();
        
        $this->assertTrue($this->_app->auth->methodCalled('logout'));
    }
}