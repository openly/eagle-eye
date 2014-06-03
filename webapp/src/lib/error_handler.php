<?php 

/**
* Errorhandler
*
* @uses     
*
* @category Category
* @package  Package
* @author   Abhi
*/
class Errorhandler
{
    /**
     * handleError
     * 
     * @param mixed $e Description.
     *
     * @access public
     * @static
     *
     * @return mixed Value.
     */
    public static function handleError($e)
    {
        $app = EagleEyeWebApp::getInstance();

        //To Do: Need to check is this valid, as if this error happens, logging will be failure
        if (!is_writable($app->get('ERROR_LOG_DIR'))) {
            throw new ErrorException("Permission Denied to write the files in Error Log Directory.");
        }

        $logFile = $app->get('ERROR_LOG_DIR') . 
                        $app->get('ERROR_LOG_FILE_PREFIX') . 
                        date('Y-m-d h:i:s') . '.log';

        $errorContent = 'ERROR: ' . $e->getMessage() . '(' . $e->getCode() . ')'. NEW_LINE;
        $errorContent .= 'TIME: '. date('Y-m-d h:i:s A') . NEW_LINE;
        $errorContent .= 'SESSION: ' . print_r($_SESSION, true) . NEW_LINE;
        $errorContent .= 'POST: ' . print_r($_POST, true) . NEW_LINE;
        $errorContent .= 'GET: ' . print_r($_GET, true) . NEW_LINE;
        $errorContent .= 'STACK TRACE: ' . $e->getTraceAsString() . NEW_LINE;
        
        file_put_contents($logFile, $errorContent);

        $pv = new PageView();
        Flight::halt('500', $pv->render('500'));
    }
}