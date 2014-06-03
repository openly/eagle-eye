<?php 
error_reporting(E_ALL & ~ E_NOTICE);
ini_set('display_errors', '1');
// Autoload every src files and everything that comes with composer.
require_once __DIR__ . '/vendor/autoload.php';

require_once __DIR__ . '/src/lib/error_handler.php';

#date_default_timezone_set('Europe/London');

define("NEW_LINE", "\n");

$app = EagleEyeWebApp::getInstance('Flight');

Flight::map('error', array('ErrorHandler','handleError'));

Analog::handler (Analog\Handler\File::init (__DIR__ . '/error_log/log.txt'));

$app->conf = new SiteConfig();
$app->auth = new WebAppAuth();
$app->session = new WebAppSession();
$app->router = new WebAppRouter('routes.json');

$app->configure($_SERVER['HTTP_HOST']);
$app->initSession();
$app->setupAuth();
$app->setupRoutes();

CSRFToken::init();
$app->conf->set('CSRF_TOKEN', CSRFToken::generate());

$app->run();