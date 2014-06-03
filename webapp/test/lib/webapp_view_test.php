<?php 

class WebAppViewTest extends PHPUnit_Framework_TestCase{

	protected function setUp(){
		$this->_invalidTemplate = "InvalidFile";
		$this->_validFile = "validTemplate";

		EagleEyeWebApp::$singletonApp = new MockObject(
			array(
				"getAllConfiguredValues" => array("dummy_conf" => "dummy_conf"),
				"get" => "test/tmp/views"
			)
		);

		$this->_singleTonApp = EagleEyeWebApp::getInstance('MockObject');
	}
	
	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage not found
     */
	public function testInvalidTemplate(){
		$view = new WebAppView();
		$view->render($this->_invalidTemplate);
	}

	public function testValidTemplate(){
		$view = new WebAppView();
		$output = $view->render($this->_validFile);
		$this->assertEquals("Key is 'dummy_key' and it's value is ''", $output);
	}

	public function testAppVarsSettingToView(){
		$view = new WebAppView();

		$vars = array("dummy_key"=>"dummy_value");
		$output = $view->render($this->_validFile, $vars);

		$this->assertTrue($this->_singleTonApp->methodCalled('getAllConfiguredValues'));
	}	

	public function testNullViewRendering(){
		$view = new WebAppView();

		$vars = null;
		$output = $view->render($this->_validFile, $vars);

		$this->assertEquals("Key is 'dummy_key' and it's value is ''", $output);
	}

	public function testViewRendering(){
		$view = new WebAppView();

		$vars = array("dummy_key"=>"dummy_value");
		$output = $view->render($this->_validFile, $vars);

		$this->assertEquals("Key is 'dummy_key' and it's value is 'dummy_value'",$output);
	}
}