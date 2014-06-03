<?php 

class PageViewTest extends PHPUnit_Framework_TestCase{

	protected function setUp(){
		$this->_invalidTemplate = "InvalidFile";
		$this->_validFile = "validTemplate";
		$this->_widgetsFile = "widgetTemplate";
		$this->_headerFooterFile = "headerFooterTemplate";

		EagleEyeWebApp::$singletonApp = new MockObject(
			array(
				"getAllConfiguredValues" => array("dummy_conf" => "dummy_conf"),
				"get" => "test/tmp/views"
			)
		);
		$this->_singleTonApp = EagleEyeWebApp::getInstance('MockObject');

		WebAppWidgetLoader::$widgetLoader = new MockObject(
			array(
				"getWidgetVars" => array("widget__testWidget__arg1"=>"Loaded From Widget")
			)
		);
		$this->_widgetLoader = WebAppWidgetLoader::getInstance();
	}

	protected function tearDown(){
		EagleEyeWebApp::$singletonApp = null;
		WebAppWidgetLoader::$widgetLoader = null;
	}
	
	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage not found
     */
	public function testInvalidTemplate(){
		$view = new PageView();
		$view->render($this->_invalidTemplate);
	}

	public function testValidTemplate(){
		$view = new PageView($this->_validFile);
		$this->assertEquals('PageView', get_class($view));
	}

	public function testViewRendering(){
		$view = new PageView();
		$vars = array("dummy_key"=>"dummy_value");
		$output = $view->render($this->_validFile, $vars);
		
		$this->assertEquals("Key is 'dummy_key' and it's value is 'dummy_value'",$output);
	}

	public function testWidgetsRendering(){
		$view = new PageView();		
		$output = $view->render($this->_widgetsFile);

		$this->assertTrue($this->_widgetLoader->methodCalled('getWidgetVars'));

		$this->assertEquals("Loaded From Widget",$output);
	}

	public function testAddHeader(){
		$view = new PageView();		
		$view->addHeader("Loaded From Header");
		$view->addHeader("Loaded From Second Header");

		$output = $view->render($this->_headerFooterFile, $vars);
		$this->assertEquals("<div>Loaded From Header\nLoaded From Second Header</div>\n<div></div>", $output);
	}

	public function testAddFooter(){
		$view = new PageView();		
		$view->addFooter("Loaded From Footer");
		$view->addFooter("Loaded From Second Footer");

		$output = $view->render($this->_headerFooterFile, $vars);
		$this->assertEquals("<div></div>\n<div>Loaded From Footer\nLoaded From Second Footer</div>", $output);
	}

	public function testAddHeaderCSS(){
		$view = new PageView();		
		$view->addHeaderCSS("valid");

		$output = $view->render($this->_headerFooterFile, $vars);
		$this->assertEquals("<div><link rel='stylesheet' type='text/css' href='test/tmp/views/css/valid.css'></div>\n<div></div>", $output);
	}

	public function testAddFooterJS(){
		$view = new PageView();		
		$view->addFooterJS("valid");

		$output = $view->render($this->_headerFooterFile, $vars);
		$this->assertEquals("<div></div>\n<div><script type='text/javascript' src='test/tmp/views/js/valid.js'></script></div>", $output);
	}
}