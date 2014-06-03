<?php 

class WebAppTest extends PHPUnit_Framework_TestCase{
    
    protected function setUp()
    {
        EagleEyeWebApp::$singletonApp = null;
    }

    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Framework cannot be null
     */
    public function testNullFramework(){
        $framework = null;
        $app = EagleEyeWebApp::getInstance($framework);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Configure cannot be null
     */
    public function testConfigureNegative(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        $app->configure();
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Routes cannot be set up without a valid router object
     */
    public function testRouteSetupNegative(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        $app->setupRoutes();
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Configure cannot be null
     */
    public function testRouteSetupBeforeConfigure(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        $app->router = new MockObject;

        $app->setupRoutes();
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Cannot run application
     */
    public function testAppRunWithoutConf(){
        $app = EagleEyeWebApp::getInstance('MockObject');

        $app->run();
    }

    public function testRouteSetupWithConf(){
        $app = EagleEyeWebApp::getInstance('MockObject');

        $app->router = new MockObject;
        $app->conf = new MockObject;
        
        $app->setupRoutes();

        $this->assertTrue($app->conf->methodCalled('configure'));
        $this->assertTrue($app->router->methodCalled('setup'));
    }

    public function testAppConfigure(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        $app->conf = new MockObject;

        $app->configure();

        $this->assertTrue($app->conf->methodCalled('configure'));
    }

    public function testRouteSetupAfterConfig(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        
        $app->router = new MockObject;
        $app->conf = new MockObject;
        $app->configure();
        
        $app->setupRoutes();

        $this->assertTrue($app->conf->methodCalled('configure'));
        $this->assertTrue($app->router->methodCalled('setup'));
    }

    public function testAuthSetup(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        $app->auth = new MockObject;

        $app->setupAuth();

        $this->assertTrue($app->auth->methodCalled('init'));
    }

    public function testSessionInit(){
        $app = EagleEyeWebApp::getInstance('MockObject');
        $app->session = new MockObject;

        $app->initSession();

        $this->assertTrue($app->session->methodCalled('init'));
    }


    public function testAppRun(){
        $app = EagleEyeWebApp::getInstance('MockObject');

        $app->router = new MockObject;
        $app->conf = new MockObject;
        $app->configure();      
        $app->setupRoutes();
        
        $app->run();

        $this->assertTrue($app->conf->methodCalled('configure'));
        $this->assertTrue($app->router->methodCalled('setup'));
        $this->assertTrue(MockObject::staticMethodCalled('start'));
    }

    public function testAppConfigGetSet(){
        $app = EagleEyeWebApp::getInstance('MockObject');

        $app->conf = new MockObject;

        $value = $app->get("dummy_key");
        $this->assertNULL($value);

        $app->conf->set("dummy_key","dummy_val");
        
        $this->assertTrue($app->conf->methodCalled('set'));
    }

    public function testAppGetAllConfig(){
        $app = EagleEyeWebApp::getInstance('MockObject');

        $conf =  new MockObject;
        $conf->dummy_key = 'dummy_val';
        $conf->dummy_key1 = 'dummy_val1';
        $app->conf = $conf;

        $value = $app->getAllConfiguredValues();
        $this->assertEquals(array(
                "dummy_key" => "dummy_val",
                "dummy_key1" => "dummy_val1"
            ),
            $value
        );
    }

    public function testRedirect(){
        $frameWork = new MockObject;
        $app = EagleEyeWebApp::getInstance($frameWork);
        
        $app->conf = new MockObject;

        $app->redirect("/test");

        $this->assertTrue($frameWork->staticMethodCalled("redirect"));
    }

    public function testHeaderRedirect(){
        $this->markTestIncomplete(
          'Unable to test due to the direct url setting to the header location'
        );

        $frameWork = new MockObject;
        $app = EagleEyeWebApp::getInstance($frameWork);

        $url = '/redirect';
        $app->headerRedirect($url);

        $headers_list = headers_list();
        $this->assertNotEmpty($headers_list);
        $this->assertContains("Location: $url", $headers_list);
    }

    public function testRequestPath(){
        $mockReqObj = new MockObject();
        $mockReqObj->base = "/base_url";
        $mockReqObj->url = "/base_url/path";

        MockObject::setStaticFunctions(array("request" => $mockReqObj));

        $frameWork = new MockObject;

        $app = EagleEyeWebApp::getInstance($frameWork);

        $path = $app->requestPath();
        $this->assertEquals("/path", $path);
    }
}