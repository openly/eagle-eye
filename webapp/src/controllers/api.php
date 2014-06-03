<?php 

/**
* APIController
*
* @uses     WebAppController
*
* @category Category
* @package  Package
* @author   Raghu
*/
class APIController extends WebAppController
{
    
    /**
     * __construct
     * 
     * @access public
     *
     * @return mixed Value.
     */
    function __construct()
    {
        parent::__construct();
        $this->serviceAppAPI = new ServiceAppAPI($this->app);
    }

    /**
     * index
     * 
     * @param mixed $path Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function index($path)
    {
        $res = $this->serviceAppAPI->get($path);
        echo json_encode($res);
    }

    /**
     * dbResult
     * 
     * @param mixed $path Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function dbResult($path)
    {
        $res = $this->serviceAppAPI->get($path);
        
        if ($res['status'] == 'success' && isset($res['result'])) {
            echo json_encode($res['result']);
        } else {
            //To DO: Handle the error better than this. This doesn't shows the errors to user
            echo json_encode(array());
        }
    }
}