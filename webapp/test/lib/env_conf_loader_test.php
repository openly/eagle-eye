<?php 

class EnvConfLoaderTest extends PHPUnit_Framework_TestCase
{

    public function setUp()
    {
        $this->_env_conf_dir = __DIR__ . '/../tmp/env_conf';
    }
    
    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Configuration Reader cannot be null
     */
    public function testNullSetConfReader()
    {
        $envConf = new EnvironmentConfLoader();
        
        $confReader = null;
        $envConf->setConfReader($confReader);
    }

    /**
     * @expectedException ErrorException
     * @expectedExceptionMessage Configuration Reader is not set
     */
    public function testConfigureWitoutSettingConfReader()
    {
        $envConf = new EnvironmentConfLoader();
        
        $app = new MockObject;
        $envConf->configure($app);
    }

    public function testBaseEnvConfigure()
    {
        $envConf = new EnvironmentConfLoader();
        
        $confReader = new MockObject();
        $envConf->setConfReader($confReader);

        $envConf->setEnvironmentConfDir($this->_env_conf_dir);
        $envConf->setBaseConfig("base_conf");

        $app = new MockObject();
        $envConf->configure($app);

        $this->assertTrue($confReader->methodCalled("addConfigFile"));
        $this->assertTrue($confReader->methodCalled("configure"));
    }

    public function testDefaultEnvConfigure()
    {
        $envConf = new EnvironmentConfLoader();
        
        $confReader = new MockObject();
        $envConf->setConfReader($confReader);

        $envConf->setEnvironmentConfDir($this->_env_conf_dir);
        $envConf->setDefaultConfig("default_conf");

        $app = new MockObject();
        $envConf->configure($app);

        $this->assertTrue($confReader->methodCalled("addConfigFile"));
        $this->assertTrue($confReader->methodCalled("configure"));
    }

    public function testEnvFileConfigure()
    {
        $envConf = new EnvironmentConfLoader();
        
        $confReader = new MockObject();
        $envConf->setConfReader($confReader);

        $envConf->setEnvironmentConfDir($this->_env_conf_dir);

        $app = new MockObject();
        $envConf->configure($app, "localhost");

        $this->assertTrue($confReader->methodCalled("addConfigFile"));
        $this->assertTrue($confReader->methodCalled("configure"));
    }
}