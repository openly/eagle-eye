<?php 

/**
* WidgetViewTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class WidgetViewTest extends PHPUnit_Framework_TestCase{

    protected function setUp(){
        EagleEyeWebApp::$singletonApp = new MockObject;
        $this->_singleTonApp = EagleEyeWebApp::getInstance();
    }
    
    public function testConstructor(){
        $view = new WidgetView();
        $this->assertTrue($this->_singleTonApp->methodCalled('get', 'WIDGET_DIR'));
    }

}