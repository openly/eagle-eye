
var express = require('express'), app = express();
var Validator = require('validator').Validator;
var crypto = require('crypto');
var mongoose= require('mongoose'),Schema = mongoose.Schema;
var hashlib = require('hashlib');hashlib.md5('text');

app.configure(function() {
	app.set('views', __dirname + '/views');
	app.set('view engine', 'jade');
	app.use(express.cookieParser());
	app.use(express.session({ secret: 'secret goes here' }));
	app.use(express.bodyParser());
	app.use(app.router);
	app.use(express.csrf());
	app.use(express.static(__dirname + '/public'));
});

app.locals.errors = {};
app.locals.message = {};

function csrf(req, res, next) {
	res.locals.token = req.session._csrf;
	next();
};
function validate(message) {
	var v = new Validator(), errors = [];
		v.error = function(msg) {
			errors.push(msg);
		};

	v.check(message.name, 'Please enter your name').len(1, 100);
	v.check(message.email, 'Please enter a valid email address').isEmail();
	v.check(message.organization, 'Please enter a valid organization').len(1, 100);
	v.check(message.password, 'Please enter your password').len(1);
	v.check(message.passwordConfirm, 'The two passwords provided do not match.').equals(message.password);
	return errors;
};
app.get('/', csrf, function(req, res) {
		res.render('index');
});

app.post('/contact', csrf, function (req, res) {
	var message = req.body.message 
	, errors = validate(message)
	, locals = {}
	;

	function render() {
		res.render('index', locals);
	}

	if (errors.length === 0) { 
		locals.notice = 'Your message has been sent.';
		var hashPassword = hashlib.md5(message.password);
		var hashPasswordConfirm = hashlib.md5(message.passwordConfirm);

		var PostSchema = new Schema({
			name: String,
			email: String,
			organization :String,
			password : String,
			passwordConfirm : String
		});
		/*Establishing connection with mongodb*/
		mongoose.connect('mongodb://localhost/EagleEye');
		mongoose.model('Post', PostSchema);

		var Post = mongoose.model('Post');
		var post = new Post();
		post.name = message.name;
		post.email = message.email;
		post.organization = message.organization;
		post.password =hashPassword;
		post.passwordConfirm =hashPasswordConfirm;
		/*save User data to the database*/
		post.save(function(err){
			if(err){
				throw err;
			}
			console.log('saved');
			Post.find({}, function(err, posts){
				if(err){ 
					console.log(err); throw err;
				}
				var obj = eval(posts);
				mongoose.disconnect();
			})
		});
		render();
	} 
	else{
		locals.error = 'Please correct the following Errors:';
		locals.errors = errors;
		render();
	}	
});
app.get('/', function (req,res) {
	res.render('index',
		{ title : 'Home'})
})
app.get('/home', function (req,res){
	res.render('home', 
		{ title: 'Home'}
	)
})
app.get('/about', function (req,res){
	res.render('about', {
		title: 'About Us'
	})
})
app.get('/contact', function (req,res){
	res.render('contact', {
		title: 'Contact'
	})
})
app.get('/application', function (req,res){
	res.render('application', {
		title: 'Application'
	})
})
app.get('/dashboard', function (req,res){
	res.render('dashboard', {
		title: 'Dashboard'
	})
})
app.get('/genericTests', function (req,res){
	res.render('genericTests', {
		title: 'Generic Tests'
	})
})
app.get('/notification', function (req,res){
	res.render('notification', {
		title: 'Notification'
	})
})
app.get('/profile', function (req,res){
	res.render('profile', {
		title: 'Profile'
	})
})
app.get('/register', function (req,res){
	res.render('register', {
		title: 'Register'
	})
})
app.get('/runTests', function (req,res){
	res.render('runTests', {
		title: 'Run Tests'
	})
})
app.get('/share', function (req,res){
	res.render('share', {
		title: 'Share'
	})
})
app.get('/webhooks', function (req,res){
	res.render('webhooks', {
		title: 'Webhooks'
	})
})
app.get('/404', function (req,res){
	res.render('404', {
		title: '404'
	})
})

app.listen(8081);
console.log('Listening on port 8081');
console.log('Request Recieved')
