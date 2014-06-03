1. Base configuration file(conf.json) will always be loaded.
    
2. The environment config files are loaded based on the the value in NODE_ENV variable.
    
3. NODE_ENV value needs to be supplied during the start of the application.[ NODE_ENV=loacal src/app.js]
   
4. NODE_ENV can have values local, stage, test, live each correspond to their respective environments

5. It is not possible to identify host as in webapp because Serviceapp needs to be provided with port and host information before the startup itself.
   
6. If NODE_ENV variable not supplied, exception will be thrown.
   
7. If the config variables exists in both the base and environment config files, then the base config values will be overridden and environment config values will be considered