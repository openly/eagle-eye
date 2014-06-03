<?php
class TestOneRenderFailureWidget extends WebAppWidget{
	public function render(){
		throw new ErrorException("Test Render Exception");
	}
}