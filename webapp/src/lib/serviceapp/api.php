<?php 

/**
* ServiceAppAPI
*
* @uses     
*
* @category Category
* @package  Package
* @author   Abhi
*/
class ServiceAppAPI
{
    private $_app;

    /**
     * __construct
     * 
     * @param mixed $app Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function __construct($app)
    {
        if (!$app) {
            throw new ErrorException("Application cannot be null.");
        }

        $this->_app = $app;

        $this->restclient = new RestClient(
            array(
                'base_url' => $this->_app->get('SERVICEAPP_URL'),
                'headers' => array(
                    'Accept'        => 'application/json'
                ),
                'data_format' => 'query'
            )
        );
    }

    /**
     * get
     * 
     * @param mixed $url    Description.
     * @param mixed $params Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function get($url, $params=null)
    {
        return $this->_callRestApi(false, $url, $params);
    }

    /**
     * post
     * 
     * @param mixed $url    Description.
     * @param mixed $params Description.
     *
     * @access public
     *
     * @return mixed Value.
     */
    public function post($url, $params=null)
    {
        return $this->_callRestApi(true, $url, $params);
    }

    /**
     * _callRestApi
     * 
     * @param mixed $isPost Description.
     * @param mixed $url    Description.
     * @param mixed $params Description.
     *
     * @access private
     *
     * @return mixed Value.
     */
    private function _callRestApi($isPost, $url, $params=null)
    {
        if ($params == null) {
            $params = array();
        }

        $url .= '?access_token=' . $this->_app->auth->getAccessToken();

        Analog::log('API Call: POST ' . $url);
        Analog::log('PARAMS: ' . print_r($params, true));

        $client = $isPost ? 
            $this->restclient->post($url, $params) :
            $this->restclient->get($url, $params);

        if ($client->response) {
            $response = json_decode($client->response, true);

            //to handle Service App InternalError
            if (!empty($response['code'])) {
                $msg = $response['code'] . ': ' . $response['message'];
                $response = array(
                    'status' => 'failure'
                    , 'errors' => array($msg)
                );
            }
            
            // clear session so the user will be logged out from webapp also
            //To Do: Response is not correct from the 
            if (isset($response['status']) && $response['status'] == "403") {
                WebAppSession::delete();
                $this->_app->auth->sessionTimeOut();
            }

            //logging in case of failed response
            if (!isset($response['status'])
                || (isset($response['status']) && $response['status'] !== "success")
            ) {
                Analog::log('Failed Response: ' . $client->response);
            }
            return $response;
        } else {
            Analog::log('Failed Response: ' . $client->response);
            return array(
                'status' => 'failure',
                'errors' => array('ERROR: No Response from Serviceapp')
            );
            //throw new ErrorException("Cannot connect to Serviceapp");
        }
    }
}