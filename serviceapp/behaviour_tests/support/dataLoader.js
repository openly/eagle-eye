var _ = require('underscore'),
	fs = require('fs'); 
module.exports = {
	//  *** `public` getDataSet : *** Function to load data set
	getDataSet : function(file, callback){
		fs.readFile(__dirname + "/../data_set/" + file + ".json", 
			'utf8',function(err,data){
			if(err){ 
				throw new Error('Cannot read file.'); 
			}
			callback(null, JSON.parse(data));
		})
	}

}
