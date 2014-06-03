<?php 

/**
* WebAppRouterTest - Test Cases for the WebAppRouter
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Library
* @package  Test
* @author   Raghu
*/
class WebAppRouterTest extends PHPUnit_Framework_TestCase
{

    protected function setUp()
    {
        $this->__invalidFile = "InvalidFile";
        $this->__invalidJSONFile = "invalidJson.json";
        $this->__invalidRouterFile = "invalidRouter.json";
        $this->__invalidRouterController = "invalidRouterController.json";
        $this->__invalidRouterActionFile = "invalidRouterAction.json";
        $this->__validFile = "router.json";

        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => "test/tmp/routers"
            )
        );
        $this->__singleTonApp = EagleEyeWebApp::getInstance('MockObject');
    }

    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage file not found
     */
    public function testInvalidRouterFilePath()
    {
        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__invalidFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }
    
    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null
     */
    public function testInvalidApplication()
    {
        $this->__singleTonApp = null;
        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__validFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Framework cannot be null
     */
    public function testInvalidFrameWork()
    {
        $mockFrameWork = null ;
        $router = new WebAppRouter($this->__validFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage cannot be decoded
     */
    public function testInvalidRouterJSON()
    {
        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__invalidJSONFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage class not found
     */
    public function testInvalidRouterController()
    {
        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__invalidRouterFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage class doesn't exists for route
     */
    public function testRouterControllerClass()
    {
        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__invalidRouterController);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Method not found for route
     */
    public function testInvalidRouterControllerAction()
    {
        $this->markTestIncomplete(
          'Unable to test due to the anonymous function'
        );

        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__invalidRouterActionFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
    }

    public function testValidRouters()
    {
        include_once __DIR__.'/../tmp/routers/testHome.php';

        $mockFrameWork = new MockObject;
        $router = new WebAppRouter($this->__validFile);
        $router->setup($this->__singleTonApp, $mockFrameWork);
        $this->assertTrue($mockFrameWork::staticMethodCalled('route'));
    }   
}