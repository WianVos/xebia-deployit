
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_jetty_db2datasource).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "jetty.DB2Datasource"
    end

    def self.properties
    
      [  "password",  "maxIdle",  "maxWait",  "jndiName",  "maxActive",  "portnumber",  "user",  "servername",  "initialSize",  "databasename",  "defaultTransactionIsolation",  "minIdle",  ]
    
    end

    def self.parent
    
      [  "jetty.Server",  "core.Directory",  ]
    
    end

    def self.autorequires
    
      [  "deployit_jetty_server",  "deployit_core_directory",  ]
    

    end

    def self.hash_properties
    
      nil
    
    end

    def self.array_properties
    
       nil
    
    end

    def self.ci_array_properties
    
      nil
    
    end
  end

      