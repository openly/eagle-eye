<?php 
/**
* PHP Unit Test file to test the Error Handler Test
*/

/**
* ErrorHandlerTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Test_Case
* @author   Raghu
*/
class ErrorHandlerTest extends PHPUnit_Framework_TestCase
{

    /**
     * setUp
     * 
     * @access protected
     *
     * @return mixed Value.
     */
    protected function setUp()
    {
        $this->_validDir = "test/tmp/error_logs/";

        if (!defined("NEW_LINE")) {
            define('NEW_LINE', "\n");
        }
        $_SESSION = array("dummy_sessions");
        $_POST = array("dummy_posts");
        $_GET = array("dummy_gets");
        
        EagleEyeWebApp::$singletonApp = null;
    }

    /**
     * tearDown
     * 
     * @access protected
     *
     * @return mixed Value.
     */
    protected function tearDown()
    {
        EagleEyeWebApp::$singletonApp = null;
        $this->_clearTestErrorLogs();
    }

    /**
     * _clearTestErrorLogs - clears all the temporary error log files created
     * 
     * @access private
     *
     * @return mixed Value.
     */
    private function _clearTestErrorLogs()
    {
        foreach (new DirectoryIterator($this->_validDir) as $fileInfo) {
            if (!$fileInfo->isDot()) {
                unlink($this->_validDir . $fileInfo->getFilename());
            }
        }
    }

    /**
     * _getContentsOfErrorLogFile - get the contents of the error log file created
     * 
     * @access private
     *
     * @return mixed Value.
     */
    private function _getContentsOfErrorLogFile()
    {
        foreach (new DirectoryIterator($this->_validDir) as $fileInfo) {
            if (!$fileInfo->isDot()) {
                return file_get_contents($this->_validDir . $fileInfo->getFilename());
            }
        }
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Permission Denied to write the files in Error Log Directory.
     */
    public function testErrorLogWritable()
    {
        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => array(
                    "params" => array(
                        "ERROR_LOG_DIR" => "duplicate_dir",
                        "ERROR_LOG_FILE_PREFIX" => "prefix"
                    )
                )
            )
        );

        $e = new MockObject(
            array(
                "getCode" => "100",
                "getMessage" => "Test Case Error Exception",
                "getTraceAsString" => "Code Stack Trace"
            )
        );
        
        Errorhandler::handleError($e);
    }

    /**
     * testHandleError
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function testHandleError()
    {
        EagleEyeWebApp::$singletonApp = new MockObject(
            array(
                "get" => array(
                    "params" => array(
                        "ERROR_LOG_DIR" => $this->_validDir,
                        "ERROR_LOG_FILE_PREFIX" => "prefix"
                    )
                )
            )
        );

        $e = new MockObject(
            array(
                "getCode" => "100",
                "getMessage" => "Test Case Error Exception",
                "getTraceAsString" => "Code Stack Trace"
            )
        );
        
        try {
            Errorhandler::handleError($e);
        } catch (Exception $e) {
            //Flight framework rendering Internal Server Error Page
            $this->assertEquals($e->getMessage(), "Array to string conversion");
        }

        $this->assertStringStartsWith(
            "ERROR: Test Case Error Exception(100)",
            $this->_getContentsOfErrorLogFile()
        );
    }
}