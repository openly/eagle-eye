<?php 

class WebAppWidgetLoaderTest extends PHPUnit_Framework_TestCase{

	protected function setUp(){
		$this->_nFWidgetString = "widget__notFoundWidget";
		$this->_classNFWidgetString = "widget__classNotFound";
		$this->_validWidgetString = "widget__test_one__arg1";
		$this->_initFailureString = "widget__test_initialize_failure__arg1";
		$this->_template = "{{{widget__test_one__arg1}}}";
		$this->_renderErrorTemplate = "{{{widget__test_one_render_failure}}}";

		EagleEyeWebApp::$singletonApp = new MockObject(
			array(
				"getAllConfiguredValues" => array("dummy_conf" => "dummy_conf"),
				"get" => "test/tmp/widgets"
			)
		);
		$this->_singleTonApp = EagleEyeWebApp::getInstance('MockObject');

        WebAppWidgetLoader::$widgetLoader = null;
	}

    protected function tearDown(){
       EagleEyeWebApp::$singletonApp = null;
       WebAppWidgetLoader::$widgetLoader = null;
    }
	
	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Widget cannot be null
     */
	public function testNullWidgetString(){
		$widgetLoader = WebAppWidgetLoader::getInstance();		
		$widgetObj = $widgetLoader->getWidgetObject(null);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage not a valid widget
     */
	public function testInvalidWidgetString(){
		$widgetLoader = WebAppWidgetLoader::getInstance();		
		$widgetObj = $widgetLoader->getWidgetObject("invalid_widget");
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage not a valid widget
     */
	public function testWidgetStringWithoutName(){
		$widgetLoader = WebAppWidgetLoader::getInstance();		
		$widgetObj = $widgetLoader->getWidgetObject("widget__");
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage class not found
     */
	public function testWidgetFileNotFound(){
		$widgetLoader = WebAppWidgetLoader::getInstance();
		$widgetObj = $widgetLoader->getWidgetObject($this->_nFWidgetString);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage class not found
     */
	public function testWidgetClassNotFound(){
		$widgetLoader = WebAppWidgetLoader::getInstance();
		$widgetObj = $widgetLoader->getWidgetObject($this->_classNFWidgetString);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Error happened while initializing the widget
     */
	public function testWidgetObjectInitializeException(){
		$widgetLoader = WebAppWidgetLoader::getInstance();		
		$widgetObj = $widgetLoader->getWidgetObject($this->_initFailureString);
	}

	public function testGetWidgetObject(){
        require_once __DIR__.'/../tmp/widgets/test_one.php';
        
		$widgetLoader = WebAppWidgetLoader::getInstance();		
		$widgetObj = $widgetLoader->getWidgetObject("widget__test_one__arg1");

		$this->assertInstanceOf("TestOneWidget", $widgetObj);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage View cannot be null
     */
	public function testNullView(){
		$mockView = null;		
		$widgetLoader = WebAppWidgetLoader::getInstance();
		
		$widgetVars = $widgetLoader->getWidgetVars($this->_template, $mockView);
	}

	public function testWidgetVars(){
		$mockView = new MockObject();
		
		$widgetLoader = WebAppWidgetLoader::getInstance();
		$widgetVars = $widgetLoader->getWidgetVars($this->_template, $mockView);

		$this->assertEquals(
			array("widget__test_one__arg1" => "Loaded From Widget"),
			$widgetVars
		);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Error happened while rendering the widget
     */
	public function testWidgetRenderingException(){
        require_once __DIR__ . '/../tmp/widgets/test_one_render_failure.php';

		$mockView = new MockObject();
		
		$widgetLoader = WebAppWidgetLoader::getInstance();
		
		$widgetVars = $widgetLoader->getWidgetVars($this->_renderErrorTemplate, $mockView);
	}
}