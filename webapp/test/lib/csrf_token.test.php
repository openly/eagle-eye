<?php 

/**
* CSRFTokenTest
*
* @uses     PHPUnit_Framework_TestCase
*
* @category Category
* @package  Package
* @author   Raghu
*/
class CSRFTokenTest extends PHPUnit_Framework_TestCase
{
    public function testGenerate()
    {
        $token = CSRFToken::generate();
        $this->assertNotNull($token);
        $this->assertEquals($_SESSION['csrf_token'], $token);
    }

    public function testValidate()
    {
        $token = "invalid";
        $this->assertFalse(CSRFToken::validate($token));

        $token = $_SESSION['csrf_token'];
        $this->assertTrue(CSRFToken::validate($token));
    }

    public function testValidateOnInit()
    {
        CSRFToken::init();

        $token = $_SESSION['csrf_token'];
        $_SESSION['csrf_token'] = null;

        $this->assertTrue(CSRFToken::validate($token));
    }
}