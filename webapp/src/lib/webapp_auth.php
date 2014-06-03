<?php 
/**
* WebAppAuth
*
* @uses     
*
* @category Category
* @package  Package
* @author   Abhi
*/
class WebAppAuth
{
    private $_app;

    /**
     * init
     * 
     * @param mixed $app Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function init($app)
    {
        if (!$app) {
            throw new ErrorException("Application cannot be null.");
        }

        $this->_app = $app;
        $this->serviceAppModel = new ServiceAppLogin($app);
    }

    /**
     * login
     * 
     * @param mixed $user Description.
     * @param mixed $pass Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function login($user, $pass)//, $remember)
    {
        if (!$this->_app) {
            throw new ErrorException("WebAppAuth is not initialized");
        }

        $res = $this->serviceAppModel->login($user, $pass);

        if ($res) {
            // $data = array(
            //     "user" => $user,
            //     "pass" => $pass
            // );
            //$this->_rememberSession($remember, $data);

            WebAppSession::set(
                'access_token',
                $this->serviceAppModel->getLoggedInUserToken()
            );

            $user = $this->serviceAppModel->getLoggedInUserDetail();
            WebAppSession::set(
                'full_name',
                $user['first_name'] . ' ' . $user['last_name']
            );
            WebAppSession::set('email', $user['email']);
            WebAppSession::set('roles', $user['roles']);

            WebAppSession::set(
                'customer',
                $this->serviceAppModel->getLoggedInUsersCustomer()
            );
            WebAppSession::set(
                'accountManager',
                $this->serviceAppModel->getLoggedInUsersAccountManager()
            );
            WebAppSession::set(
                'serviceDeliveryManager',
                $this->serviceAppModel->getLoggedInUsersSDManager()
            );

            $this->_app->redirect('/');
        }

        return false;
    }

    /**
     * logout
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function logout()
    {
        if (!$this->_app) {
            throw new ErrorException("WebAppAuth is not initialized");
        }

        if ($this->isLoggedIn()) {
            $this->serviceAppModel->logout();
        }

        //clears the cookies saved for remember me functionality
        //$this->_rememberSession();
        WebAppSession::delete();

        $this->_app->redirect('/login');
    }

    /**
     * isLoggedIn
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function isLoggedIn()
    {
        return WebAppSession::get('access_token') != null;
        // commented for remember me funcionality 
        // $cookie = $this->_app->get('COOKIE_NAME');
        // $cookie_value = $_COOKIE[$cookie];
        // $isCookieSet = !empty($cookie_value);
        // if (WebAppSession::get('access_token') != null) {
        //     if ($isCookieSet) {
        //         //reset the cookie so that it will expire
        //         // since the last active
        //         $expireDays = '+' . $this->_app->get('COOKIE_EXPIRE_DAYS') . ' days';
        //         setcookie(
        //             $cookie,
        //             $cookie_value,
        //             strtotime($expireDays)
        //         );
        //     }
        //     return true;
        // } elseif ($isCookieSet) {
        //     //If remembered then login using saved usernames and passwords
        //     //To Do: Effects in Change Password functionality
        //     $file = $_COOKIE[$this->_app->get('COOKIE_NAME')];
        //     $data = $this->_getDecryptedData($file);
        //     $this->_removeEncryptedData($file);
        //     if (!$data) {
        //         return false;
        //     }
        //     return $this->login(
        //         $data['user'],
        //         $data['pass'],
        //         true
        //     );
        // } else {
        //     return false;
        // }
    }

    /**
     * isAuthroished
     * 
     * @param mixed $role       Description.
     * @param mixed $nextMethod Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function isAuthroished($role,$nextMethod)
    {
        $auth = $this;
        return function () use ($role, $nextMethod, $auth) {
            if ($auth->isLoggedIn() && $auth->hasRole($role)) {
                call_user_func_array($nextMethod, func_get_args());
            } else {
                $auth->header403Forbidden();
            }
        };
    }

    /**
     * header403Forbidden
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function header403Forbidden()
    {
        header('HTTP/1.0 403 Forbidden');
        $v = new PageView();
        $vars = array(
            'hasErrors' => true, 
            'error'     => array('You are not authorised to access this page.')
        );
        echo $v->render('login', $vars);
        exit;
    }

    /**
     * sessionTimeOut
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function sessionTimeOut()
    {
        header('HTTP/1.0 440 Session Timeout');
        $v = new PageView();
        $vars = array(
            'hasErrors' => true, 
            'error'     => array('Your session is expired. Please login again')
        );
        echo $v->render('login', $vars);
        exit;
    }

    /**
     * hasRole
     * 
     * @param mixed $role Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function hasRole($role)
    {
        return is_array(WebAppSession::get('roles')) 
            && in_array($role, WebAppSession::get('roles'));
    }

    /**
     * getAccessToken
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function getAccessToken()
    {
        return WebAppSession::get('access_token');
    }

    //Remember Me: As of now commented. But may be required in future
    //Set these variables in the base_conf.json
    // "COOKIE_FILE_PATH"        : "${APP_DIR}/cookies/",
    // "COOKIE_EXPIRE_DAYS"      : "30",
    // "COOKIE_NAME"             : "ORANGE_COOKIES",
    // "COOKIE_SALT"             : "bcb04b7e103a0"
    //======================================
    // /**
    //  * _rememberSession - implements the remember me functionality
    //  * 
    //  * @param mixed $remember Description.
    //  * @param array $data     Description.
    //  *
    //  * @access private
    //  *
    //  * @return mixed Value.
    //  */
    // private function _rememberSession($remember=null, $data=array())
    // {
    //     $cookie = $this->_app->get('COOKIE_NAME');
    //     if (!empty($remember)) {
    //         $file_name = uniqid('cookie_');
    //         $this->_saveEncryptedData($file_name, $data);
    //         $expireDays = '+' . $this->_app->get('COOKIE_EXPIRE_DAYS') . ' days';
    //         setcookie(
    //             $cookie,
    //             $file_name,
    //             strtotime($expireDays)
    //         );
    //     } else {
    //         $file_name = $_COOKIE[$cookie];
    //         $this->_removeEncryptedData($file_name);
    //         setcookie(
    //             $cookie,
    //             '',
    //             time() - 100
    //         );
    //     }
    // }

    // /**
    //  * __saveEncryptedData
    //  * 
    //  * @param mixed $file Description.
    //  * @param mixed $data Description.
    //  *
    //  * @access private
    //  *
    //  * @return mixed Value.
    //  */
    // private function _saveEncryptedData($file, $data)
    // {
    //     $file = $this->_app->get('COOKIE_FILE_PATH') . $file;
    //     try {
    //         $encryptObj = WebAppEncrypt::getInstance();
    //         $data = $encryptObj->encrypt(json_encode($data));

    //         return file_put_contents($file, $data);
    //     } catch (Exception $e) {
    //         return false;
    //     }
    // }

    // /**
    //  * _getDecryptedData
    //  * 
    //  * @param mixed $file Description.
    //  *
    //  * @access private
    //  *
    //  * @return mixed Value.
    //  */
    // private function _getDecryptedData($file)
    // {
    //     $file = $this->_app->get('COOKIE_FILE_PATH') . $file;
    //     try {
    //         $data = file_get_contents($file);

    //         $encryptObj = WebAppEncrypt::getInstance();
    //         return json_decode($encryptObj->decrypt($data), true);
    //     } catch(Exception $e) {
    //         return false;
    //     }
    // }

    // /**
    //  * _removeEncryptedData
    //  * 
    //  * @param mixed $file Description.
    //  *
    //  * @access private
    //  *
    //  * @return mixed Value.
    //  */
    // private function _removeEncryptedData($file)
    // {
    //     $path = $this->_app->get('COOKIE_FILE_PATH') . $file;
    //     try {
    //         return unlink($path);
    //     } catch (Exception $e) {
    //         return false;
    //     }
    // }
    //=========Remember Me Ends ===================================
}