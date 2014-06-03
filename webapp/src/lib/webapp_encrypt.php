<?php

//This was used for remember me functinality.
//But that has been removed and hence commented out

// /**
// * EncryptDecrypt
// *
// * @uses     
// *
// * @category Library
// * @package  WebApp
// * @author   Raghu
// */
// class WebAppEncrypt
// {

//     private $_securekey;

//     public static $singleTonClass;

//     /**
//      * __construct
//      * 
//      * @access private
//      *
//      * @return mixed Value.
//      */
//     private function __construct()
//     {
//         $app = EagleEyeWebApp::getInstance();
//         $this->_securekey = $app->get('COOKIE_SALT');
//     }

//     /**
//      * getInstance
//      * 
//      * @access public
//      * @static
//      *
//      * @return mixed Value.
//      */
//     public static function getInstance()
//     {
//         if (self::$singleTonClass === null) {
//             self::$singleTonClass = new WebAppEncrypt();
//         }
//         return self::$singleTonClass;
//     }

//     /**
//      * encrypt
//      * 
//      * @param mixed $encrypt Description.
//      *
//      * @access public
//      *
//      * @return mixed Value.
//      */
//     public function encrypt($encrypt)
//     {
//         $encrypt = serialize($encrypt);
//         $iv = mcrypt_create_iv(
//             mcrypt_get_iv_size(
//                 MCRYPT_RIJNDAEL_256,
//                 MCRYPT_MODE_CBC
//             ),
//             MCRYPT_DEV_URANDOM
//         );
//         $key = pack('H*', $this->_securekey);
//         $mac = hash_hmac(
//             'sha256',
//             $encrypt,
//             substr(bin2hex($key), -32)
//         );
//         $passcrypt = mcrypt_encrypt(
//             MCRYPT_RIJNDAEL_256,
//             $key,
//             $encrypt . $mac,
//             MCRYPT_MODE_CBC,
//             $iv
//         );
//         $encoded = base64_encode($passcrypt) . '|' . base64_encode($iv);
//         return $encoded;
//     }

//     /**
//      * decrypt
//      * 
//      * @param mixed $decrypt Description.
//      *
//      * @access public
//      *
//      * @return mixed Value.
//      */
//     public function decrypt($decrypt)
//     {
//         $decrypt = explode('|', $decrypt);
//         $decoded = base64_decode($decrypt[0]);
//         $iv = base64_decode($decrypt[1]);
//         $key = pack('H*', $this->_securekey);
//         $decrypted = trim(
//             mcrypt_decrypt(
//                 MCRYPT_RIJNDAEL_256,
//                 $key,
//                 $decoded,
//                 MCRYPT_MODE_CBC,
//                 $iv
//             )
//         );
//         $mac = substr($decrypted, -64);
//         $decrypted = substr($decrypted, 0, -64);
//         $calcmac = hash_hmac(
//             'sha256',
//             $decrypted,
//             substr(bin2hex($key), -32)
//         );

//         if ($calcmac !== $mac) {
//             return false;
//         }

//         $decrypted = unserialize($decrypted);
//         return $decrypted;
//     }
// }