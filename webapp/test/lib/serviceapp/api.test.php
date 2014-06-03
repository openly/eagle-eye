<?php 

/**
* ServiceAppAPITest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class ServiceAppAPITest extends PHPUnit_Framework_TestCase
{
    
    protected function setUp()
    {
        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => array(
                    "params" => array(
                        "SERVICEAPP_URL" => "http://localhost:4444/",
                    )
                )
            )
        );
        $this->_app = EagleEyeWebApp::getInstance();
        $this->_app->auth = new MockObject(
            array(
                "getAccessToken" => 'some_access_token'
            )
        );;

        $this->_restClient = new MockObject(
            array(
                "get" => (object) array('response' => '["validResponse"]'),
                "post" => (object) array('response' => '["validResponse"]')
            )
        );
        $this->_failRestClient = new MockObject(
            array(
                "get" => (object) array('response' => false),
                "post" => (object) array('response' => null)
            )
        );

        $this->_url = 'testurl';
        $this->_params = array('testParams');

        $_SESSION = array();
        @session_start();
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Application cannot be null.
     */
    public function testEmptyInitialization()
    {
        $mockWebApp = null;
        $api = new ServiceAppAPI($mockWebApp);
    }

    public function testInitialization()
    {
        $api = new ServiceAppAPI($this->_app);

        $this->assertTrue($this->_app->methodCalled('get', 'SERVICEAPP_URL'));
        $this->assertInstanceOf('ServiceAppAPI', $api);
    }

    public function testFailGet()
    {
        $api = new ServiceAppAPI($this->_app);
        $api->restclient = $this->_failRestClient;

        $response = $api->get($this->_url, $this->_params);
        $this->assertTrue(
            $this->_failRestClient->methodCalled(
                'get',
                array($this->_url . '?access_token=some_access_token', $this->_params)
            )
        );
        $this->assertEquals(
            $response,
            array(
                'status' => 'failure'
                , 'errors' => array('ERROR: No Response from Serviceapp')
            )
        );
    }

    public function testGetWithEmptyParams()
    {
        $api = new ServiceAppAPI($this->_app);
        $api->restclient = $this->_restClient;

        $response = $api->get("testurl");
        $this->assertTrue(
            $this->_restClient->methodCalled(
                'get',
                array($this->_url . '?access_token=some_access_token', array())
            )
        );
        $this->assertEquals(array("validResponse"), $response);
    }

    public function testGet()
    {
        $api = new ServiceAppAPI($this->_app);
        $api->restclient = $this->_restClient;

        $response = $api->get($this->_url, $this->_params);
        $this->assertTrue(
            $this->_restClient->methodCalled(
                'get',
                array($this->_url . '?access_token=some_access_token', $this->_params)
            )
        );
        $this->assertEquals(array("validResponse"), $response);
    }

    public function testFailPost()
    {
        $api = new ServiceAppAPI($this->_app);
        $api->restclient = $this->_failRestClient;

        $response = $api->post($this->_url, $this->_params);
        $this->assertTrue(
            $this->_failRestClient->methodCalled(
                'post',
                array($this->_url . '?access_token=some_access_token', $this->_params)
            )
        );
        $this->assertEquals(
            $response,
            array(
                'status' => 'failure'
                , 'errors' => array('ERROR: No Response from Serviceapp')
            )
        );
    }

    public function testPostWithEmptyParams()
    {
        $api = new ServiceAppAPI($this->_app);
        $api->restclient = $this->_restClient;

        $response = $api->post("testurl");
        $this->assertTrue(
            $this->_restClient->methodCalled(
                'post',
                array($this->_url . '?access_token=some_access_token', array())
            )
        );
        $this->assertEquals(array("validResponse"), $response);
    }

    public function testPost()
    {
        $api = new ServiceAppAPI($this->_app);
        $api->restclient = $this->_restClient;

        $response = $api->post($this->_url, $this->_params);
        $this->assertTrue(
            $this->_restClient->methodCalled(
                'post',
                array($this->_url . '?access_token=some_access_token', $this->_params)
            )
        );
        $this->assertEquals(array("validResponse"), $response);
    }

    public function testServiceAppErrors()
    {
        $api = new ServiceAppAPI($this->_app);

        $serviceAppErrorResponse = new MockObject(
            array(
                "get" => (object) array(
                    'response' => '{"code":"403","message":"Service App Node Error Message"}'
                )
            )
        );
        $api->restclient = $serviceAppErrorResponse;

        $response = $api->get($this->_url, $this->_params);
        $this->assertTrue(
            $serviceAppErrorResponse->methodCalled(
                'get',
                array($this->_url . '?access_token=some_access_token', $this->_params)
            )
        );
        $this->assertEquals(
            array(
                'status' => 'failure'
                , 'errors' => array('403: Service App Node Error Message')
            ),
            $response
        );
    }

    public function test403NotAuthorisedResponse()
    {
        $api = new ServiceAppAPI($this->_app);

        $notAuthorisedResponse = new MockObject(
            array(
                "post" => (object) array(
                    'response' => '{"status":"403","message":"Not Authorised"}'
                )
            )
        );
        $api->restclient = $notAuthorisedResponse;

        $url = 'testurl';
        $params = array('testParams');
        $response = $api->post($this->_url, $this->_params);
        $this->assertTrue(
            $notAuthorisedResponse->methodCalled(
                'post',
                array($this->_url . '?access_token=some_access_token', $this->_params)
            )
        );
        $this->assertTrue($this->_app->auth->methodCalled('sessionTimeOut'));
    }
}