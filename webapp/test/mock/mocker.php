<?php
/**
* Mock Object to use in the PHP Unit test cases
*/ 

/**
* MockObject
*
* @uses     
*
* @category Test
* @author   Raghu
*/
class MockObject
{
    private static $_calledStaticFunctions = array();
    private static $_availableStaticFunctions = array();
    private $_calledInstanceFunctions = array();
    private $_availableInstanceFunctions = array();

    /**
     * __construct
     * 
     * @param mixed $params Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    function __construct($params = null)
    {
        if ($params) {
            $this->_availableInstanceFunctions = $params;
        }
    }

    /**
     * __call
     * 
     * @param mixed $funcName Description.
     * @param mixed $params   Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function __call($funcName, $params)
    {
        $this->_calledInstanceFunctions[$funcName][] = json_encode($params);
        return $this->_getMockFunctionReturnValue($funcName, $params);
    }

    /**
     * methodCalled
     * 
     * @param mixed $funcName Description.
     * @param mixed $params   Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function methodCalled($funcName, $params = null)
    {
        $functionCalled = array_key_exists($funcName, $this->_calledInstanceFunctions);
        if (!$params) {
            return $functionCalled;
        } else if ($functionCalled) {
            if (!is_array($params)) {
                $params = array($params);
            }
            $params = json_encode($params);
            return in_array($params, $this->_calledInstanceFunctions[$funcName]);    
        }
        return false;        
    }

    /**
     * _getMockFunctionReturnValue
     * 
     * @param mixed $funcName Description.
     * @param mixed $params   Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _getMockFunctionReturnValue($funcName, $params)
    {
        if (array_key_exists($funcName, $this->_availableInstanceFunctions)) {
            if (is_array($this->_availableInstanceFunctions[$funcName])
                && array_key_exists("params", $this->_availableInstanceFunctions[$funcName])
                && !empty($params)
            ) {
                if (is_array($params)) {
                    $params = implode(',', $params);
                }
                if (array_key_exists($params, $this->_availableInstanceFunctions[$funcName]['params'])) {
                    return $this->_availableInstanceFunctions[$funcName]['params'][$params];
                }
            }

            return $this->_availableInstanceFunctions[$funcName];
        }
    }

    /**
     * __callStatic
     * 
     * @param mixed $funcName Description.
     * @param mixed $params   Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function __callStatic($funcName,$params)
    {
        self::$_calledStaticFunctions[] = $funcName;
        return self::_getStaticMockFunctionReturnValue($funcName, $params);
    }

    /**
     * staticMethodCalled
     * 
     * @param mixed $funcName Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function staticMethodCalled($funcName)
    {
        return in_array($funcName, self::$_calledStaticFunctions);
    }

    /**
     * setStaticFunctions
     * 
     * @param mixed $params Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function setStaticFunctions($params)
    {
        if (!empty($params)) {
            self::$_availableStaticFunctions = $params;
        }
    }

    /**
     * _getStaticMockFunctionReturnValue
     * 
     * @param mixed $funcName Description.
     * @param mixed $params   Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private static function _getStaticMockFunctionReturnValue($funcName, $params)
    {
        if (array_key_exists($funcName, self::$_availableStaticFunctions)) {
            if (is_array(self::$_availableStaticFunctions[$funcName])
                && array_key_exists("params", self::$_availableStaticFunctions[$funcName])
                && !empty($params)
            ) {
                if (is_array($params)) {
                    $params = implode(',', $params);
                }
                if (array_key_exists($params, self::$_availableStaticFunctions[$funcName]['params'])) {
                    return self::$_availableStaticFunctions[$funcName][$params];
                }
            }
                
            return self::$_availableStaticFunctions[$funcName];
        }
    }
}