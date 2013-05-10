
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_was_oracledatasourcespec).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "was.OracleDatasourceSpec"
    end

    def self.properties
    
      [  "datasourceHelperClassname",  "username",  "description",  "ConnectionPool_connectionTimeout",  "password",  "URL",  "ConnectionPool_maxConnections",  "ConnectionPool_minConnections",  "jdbcProvider",  "jndiName",  ]
    
    end

    def self.parent
    
       nil
    
    end

    def self.autorequires
    
      nil
    

    end

    def self.hash_properties
    
      nil
    
    end

    def self.array_properties
    
      [  "tags",  ]
    
    end

    def self.ci_array_properties
    
      nil
    
    end
  end

      