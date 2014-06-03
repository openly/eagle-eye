<?php

/**
* StatusMessageWidget - status message widget to show the success/error/warning/info messages
*
* @uses     WebAppWidget
*
* @category Widget
* @package  Package
* @author   Raghu
*/
class StatusMessageWidget extends WebAppWidget
{

    /**
     * render
     * 
     * @access public
     *
     * @return mixed Value.
     */
    public function render()
    {
        $msgs = WebAppSession::get('messages');
        
        if (!empty($msgs['success'])) {
            $msgs['hasSuccessMsg'] = true;
        }
        if (!empty($msgs['errors'])) {
            $msgs['hasErrorMsg'] = true;
        }
        if (!empty($msgs['warning'])) {
            $msgs['hasWarningMsg'] = true;
        }
        if (!empty($msgs['info'])) {
            $msgs['hasInfoMsg'] = true;
        }

        WebAppSession::delete('messages');

        return $this->widgetView->render('status_message', $msgs);
    }
}