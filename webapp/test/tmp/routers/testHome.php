<?php
class TestHomeController extends WebAppController{
	public function index(){
		$view = new PageView('index',$this->_app);
		echo $view->render();
	}

	public function asdf(){
		$view = new PageView('index',$this->_app);
		echo $view->render();
	}
}