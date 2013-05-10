
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_wls_datasourcespec).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "wls.DataSourceSpec"
    end

    def self.properties
    
      [  "JDBCConnectionPoolParams_InitialCapacity",  "username",  "url",  "restartTarget",  "password",  "JDBCConnectionPoolParams_MaxCapacity",  "driverName",  "jndiNames",  "JDBCConnectionPoolParams_CapacityIncrement",  "targetRestartPolicy",  ]
    
    end

    def self.parent
    
       nil
    
    end

    def self.autorequires
    
      nil
    

    end

    def self.hash_properties
    
      [  "properties",  ]
    
    end

    def self.array_properties
    
      [  "tags",  ]
    
    end

    def self.ci_array_properties
    
      nil
    
    end
  end

      