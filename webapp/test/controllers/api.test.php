<?php 

/**
* StatiContentControllerTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class APIControllerTest extends PHPUnit_Framework_TestCase
{
    
    protected function setUp()
    {
        EagleEyeWebApp::$singletonApp = new MockObject;
        $this->_serviceAppApiMock = new MockObject(
            array(
                'get' =>array(
                    'status' => 'success'
                    , 'result' => 1
                )
            )
        );
        $this->_failedServiceAppApiMock = new MockObject(
            array(
                'get' =>array(
                    'status' => 'failure'
                    , 'result' => 1
                )
            )
        );
    }

    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
    }

    public function testIndex()
    {
        $this->expectOutputString('{"status":"success","result":1}');

        $api = new APIController();
        $api->serviceAppAPI = $this->_serviceAppApiMock;

        $api->index('/');

        $this->assertTrue($this->_serviceAppApiMock->methodCalled('get'));
    }

    public function testDbResult()
    {
        $this->expectOutputString('1');

        $api = new APIController();
        $api->serviceAppAPI = $this->_serviceAppApiMock;

        $api->dbResult('/');

        $this->assertTrue($this->_serviceAppApiMock->methodCalled('get'));
    }

    public function testFailDbResult()
    {
        $this->expectOutputString('[]');

        $api = new APIController();
        $api->serviceAppAPI = $this->_failedServiceAppApiMock;

        $api->dbResult('/');

        $this->assertTrue($this->_failedServiceAppApiMock->methodCalled('get'));
    }
}