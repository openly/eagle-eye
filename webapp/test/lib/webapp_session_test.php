<?php 

class WebAppSessionTest extends PHPUnit_Framework_TestCase
{

    protected function setUp()
    {
        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => "test_session"
            )
        );
        $this->_singleTonApp = EagleEyeWebApp::getInstance('MockObject');
    }

    public function testSessionInit()
    {
        $this->markTestIncomplete(
            'Unable to test due to the session_start error in phpunit i.e., Cannot send session cookie - headers already sent'
        );
        $webApp = new WebAppSession();
        $webApp->init();
        $isSessionStarted = session_id('test_session');
        $this->assertTrue($isSessionStarted);
    }

    public function testSetSession()
    {
        WebAppSession::set("test", "value");
        $this->assertEquals("value", $_SESSION['test']);
    }

    public function testGetSession()
    {
        WebAppSession::set("test", "value");
        $getVlue = WebAppSession::get("test");
        $this->assertEquals("value", $getVlue);
    }

    public function testDelete()
    {
        WebAppSession::set("test", "value");
        WebAppSession::delete("test");
        
        $this->assertEquals("", $_SESSION['test']);
    }

    public function testFullDelete()
    {
        WebAppSession::set("test", "value");
        WebAppSession::set("test2", "value2");

        WebAppSession::delete();
        
        $this->assertEquals(array(), $_SESSION);
    }
}