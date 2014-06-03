<?php 

class SubstituteTest extends PHPUnit_Framework_TestCase{

	protected function setUp(){
		$this->_appFunctions = array(
			"get" => "app_value"
		);
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null
     */
	public function testNullApplication(){
		$mockWebApp = null;
		$value = null;
		
		$value = Substitute::fromAppConf($mockWebApp, $value);
	}

	public function testNullValue(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$value = null;

		$value = Substitute::fromAppConf($mockWebApp, $value);
		$this->assertEquals("", $value);
	}

	public function testFromAppConf(){
		$mockWebApp = new MockObject($this->_appFunctions);
		$our_value = '${APP_DIR}';
		
		$value = Substitute::fromAppConf($mockWebApp, $our_value);
		$this->assertEquals("app_value", $value);
	}


}