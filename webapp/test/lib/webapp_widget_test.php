<?php 

class WidgetsTest extends PHPUnit_Framework_TestCase{

	/**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null
     */
	public function testNullApplication(){
		$mockWebApp = null;
		$args = null;
		
		$wdgt = new WebAppWidget($mockWebApp, $args);
	}

	public function testWebAppWidget(){
		$mockWebApp = new MockObject();
		$args = null;

		$wdgt = new WebAppWidget($mockWebApp, $args);
		$this->assertInstanceOf("WebAppWidget", $wdgt);
	}
}