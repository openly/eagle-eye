<?php 

/**
* LoginController
*
* @uses     WebAppController
*
* @category Category
* @package  Package
* @author   Raghu
*/
class LoginController extends WebAppController
{
    /**
     * index
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function index()
    {
        if ($this->app->auth->isLoggedIn()) {
            $this->app->redirect('/dashboard');
        } else {
            echo $this->pageView->render('login');
        }
    }

    /**
     * doLogin
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function doLogin()
    {
        if (empty($_POST['username']) || empty($_POST['password'])) {
            $data = array(
                'username' => $_POST['username']
            );
            $errors = 'Username/Password cannot be blank';
        } else {
            //if logged in page will redirect to dashboard page here itself 
            $loggedIn = $this->app->auth->login(
                $_POST['username'],
                $_POST['password']
            );

            if ($loggedIn) {
                //this is a dead code
                echo "Login successful...";
                return;
            } else {
                $data = array(
                    'username' => $_POST['username']
                );
                $errors = 'Login failed';
            }
        }

        WebAppSession::set(
            'messages',
            array('errors' => $errors)
        );

        echo $this->pageView->render('login', $data);
        return;
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
        $this->app->auth->logout();
    }
}