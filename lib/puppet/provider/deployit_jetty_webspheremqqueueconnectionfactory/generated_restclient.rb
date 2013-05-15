
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_jetty_webspheremqqueueconnectionfactory).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
    #this type is generated with genres
    # generated for deployit 3.8.5
  
    
    def initialize(value)
      super(value)
      @deployit_type = self.class.deployit_type
      @properties = self.class.properties
      @parent = self.class.parent
      @array_properties = self.class.array_properties
      @hash_properties = self.class.hash_properties
    end

    def self.deployit_type
      "jetty.WebsphereMQQueueConnectionFactory"
    end

    def self.properties
    
      [  "jndiName",  "hostName",  "CCDTURL",  "queueManager",  "channel",  ]
    
    end

    def self.parent
    
      [  "jetty.Server",  "core.Directory",  ]
    
    end

    def self.autorequires
    
      [  "deployit_jetty_server",  "deployit_core_directory",  ]
    

    end

    def self.hash_properties
    
      [  "customProperties",  ]
    
    end

    def self.array_properties
    
       nil
    
    end

    def self.ci_array_properties
    
      nil
    
    end
  end

      