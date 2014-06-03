<?php 

class CSRFToken{
	private static $oldToken;

	public static function init(){
		self::$oldToken = $_SESSION['csrf_token'];
	}

	public static function generate(){ 
		$token = uniqid();
		$_SESSION['csrf_token'] = $token;
		return $token;
	}

	public static function validate($token){
		return ($token == $_SESSION['csrf_token'] || $token == self::$oldToken);
	}
}