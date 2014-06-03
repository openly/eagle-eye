<?php 

class ConfReaderTest extends PHPUnit_Framework_TestCase{

	private $__invalidFile;
	private $__validFile;

	protected function setUp(){
		$this->__invalidFile = "InvalidFile";
		$this->__invalidJSONFile = "test/tmp/invalidJson.json";
		$this->__validFile = "test/tmp/conf.json";
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage file not found
     */
	public function testInvalidConfFilePath(){
		$conf = new ConfReader($this->__invalidFile);
	}


	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage cannot be decoded
     */
	public function testInvalidJSONInConf(){
		$mockWebApp = new MockObject;
		$conf = new ConfReader($this->__invalidJSONFile);
		$conf->configure($mockWebApp);		
	}

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null
     */
	public function testInvalidApplication(){
		$mockWebApp = null;
		$conf = new ConfReader($this->__validFile);
		$conf->configure($mockWebApp);
	}

	public function testValidFilePath(){
		$mockWebApp = new MockObject;
		$conf = new ConfReader($this->__validFile);
		$conf->configure($mockWebApp);
		$this->assertTrue($mockWebApp->methodCalled('set'));
	}	
}