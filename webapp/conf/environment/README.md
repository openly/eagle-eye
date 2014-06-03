# Environment Aware Config:

    Base configuration file(base_conf.json) will always be loaded.

    The environment config files are loaded based on the server's 'HTTP_HOST'.
    i.e., if the server's 'HTTP_HOST' is localhost, then 'localhost.json' config file will be loaded

    If the environment config file doesn't exists, then by default 'localhost.json' config file will be loaded. 

    If the config variables exists in both the base and environment config files, then the base config values will be overridden and environment config values will be considered.

    The configuration files to be loaded as Base and Default, needs to be set in the environment configration loader.