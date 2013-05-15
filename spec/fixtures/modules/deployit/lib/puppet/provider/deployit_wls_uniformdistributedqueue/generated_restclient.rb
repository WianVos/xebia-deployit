
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_wls_uniformdistributedqueue).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "wls.UniformDistributedQueue"
    end

    def self.properties
    
      [  "jndiName",  "subDeploymentName",  "jmsModuleName",  ]
    
    end

    def self.parent
    
      [  "wls.JmsTarget",  "core.Directory",  ]
    
    end

    def self.autorequires
    
      [  "deployit_wls_jmstarget",  "deployit_core_directory",  ]
    

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

      