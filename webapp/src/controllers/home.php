<?php
/**
* HomeController
*
* @uses     WebAppController
*
* @category Category
* @package  Package
* @author   Raghu
*/
class HomeController extends WebAppController
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
        $app = EagleEyeWebApp::getInstance();

        echo $this->pageView->render('home');
    }


    /**
     * redirect
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function redirect()
    {
        if ($this->app->auth->isLoggedIn()) {
            $this->app->redirect('/dashboard');
        } else {
            $this->app->redirect('/login');
        }
    }

}