
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_jetty_webspheremqqueueconnectionfactory).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
    #this type is generated with genres
    # generated for deployit 3.8.5
  
    confine :feature => :restclient
    
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
    
      [  "hostName",  "channel",  "queueManager",  "CCDTURL",  "jndiName",  ]
    
    end

    def self.parent
    
      [  "jetty.Server",  ]
    
    end

    def self.autorequires
    
      [  "deployit_jetty_server",  ]
    

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

      