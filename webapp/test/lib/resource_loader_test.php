<?php 

class ResourceLoaderTest extends PHPUnit_Framework_TestCase{

	protected function setUp(){
		$this->_appFunctions = array(
			"get" => "test/tmp/resource_loader"
		);
		ResourceLoader::$resourceLoader = null;
	}

	protected function tearDown(){
		ResourceLoader::$resourceLoader = null;
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null
     */
	public function testNullAppResourceLoaderInstance(){
		$mockWebApp = null;
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
	}

	public function testResourceLoaderInstance(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$this->assertInstanceOf('ResourceLoader', $resource_loader);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage JS file name cannot be empty
     */
	public function testNullJsResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$resource_loader->getJS("");
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage file not found
     */
	public function testInvalidJsResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$resource_loader->getJS("invalid");
	}

	public function testGetJsResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$js = $resource_loader->getJS("valid", "widget");
		$this->assertEquals("<script type='text/javascript' src='test/tmp/resource_loader/js/valid.js'></script>", $js);
	}

	public function testDuplicateJsResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		
		$js = $resource_loader->getJS("valid");
		$duplicateJS = $resource_loader->getJS("valid");

		$this->assertEquals("<script type='text/javascript' src='test/tmp/resource_loader/js/valid.js'></script>", $js);
		$this->assertFalse($duplicateJS);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage CSS file name cannot be empty
     */
	public function testNullCssesource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$resource_loader->getCSS("");
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage file not found
     */
	public function testInvalidCssResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$resource_loader->getCSS("invalid");
	}

	public function testGetCssResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$css = $resource_loader->getCSS("valid","widget");
		$this->assertEquals("<link rel='stylesheet' type='text/css' href='test/tmp/resource_loader/css/valid.css'>", $css);
	}

	public function testDuplicateCssResource(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$resource_loader = ResourceLoader::getInstance($mockWebApp);
		$css = $resource_loader->getCSS("valid");
		$duplicateCSS = $resource_loader->getCSS("valid");

		$this->assertEquals("<link rel='stylesheet' type='text/css' href='test/tmp/resource_loader/css/valid.css'>", $css);
		$this->assertFalse($duplicateCSS);
	}
}