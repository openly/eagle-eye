<?php 
/**
* Substitute
*
* @uses     
*
* @category Category
* @package  Package
* @author   Abhi
*/
class Substitute
{
    /**
     * fromAppConf
     * 
     * @param mixed &$app Description.
     * @param mixed $val  Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function fromAppConf(&$app, $val)
    {
        if (!$app) {
            throw new ErrorException("Application cannot be null");
        }
        
        while (preg_match('/\$\{(.*?)\}/', $val, $matches)) {
            $varname = $matches[1];
            $val = preg_replace('/\$\{' . $varname . '\}/', $app->get($varname), $val);
        }
        return $val;
    }
}