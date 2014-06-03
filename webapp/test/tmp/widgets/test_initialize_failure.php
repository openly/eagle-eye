<?php
class TestInitializeFailureWidget extends WebAppWidget{
	public function __construct(&$app){
		parent::__construct($app);
		throw new ErrorException("Test Initialize Exception");
	}
}