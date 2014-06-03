<?php 

/**
* HomeControllerTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class HomeControllerTest extends PHPUnit_Framework_TestCase
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

        $this->_view = new MockObject;
    }

    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
    }

    public function testIndex()
    {
        $cont = new HomeController();
        $cont->setPageView($this->_view);
        $cont->index();

        $this->assertTrue($this->_view->methodCalled('render'), "page view render");
    }

    public function testRedirectNotLoggedIn()
    {
        $this->_app->auth = new MockObject;

        $cont = new HomeController();
        $cont->setPageView($this->_view);

        $output = $cont->redirect();
        
        $this->assertTrue($this->_app->methodCalled('redirect', '/login'));
    }

    public function testRedirectLoggedIn()
    {
        $this->_app->auth = new MockObject(
            array("isLoggedIn" => true)
        );

        $cont = new HomeController();
        $cont->setPageView($this->_view);
        
        $cont->redirect();
        
        $this->assertTrue($this->_app->methodCalled('redirect', '/dashboard'));
    }
}