
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_was_war).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "was.War"
    end

    def self.properties
    
      [  "startingWeight",  "excludeFileNamesRegex",  "contextRoot",  "preCompileJsps",  ]
    
    end

    def self.parent
    
       nil
    
    end

    def self.autorequires
    
      nil
    

    end

    def self.hash_properties
    
      [  "roleMappings",  ]
    
    end

    def self.array_properties
    
      [  "tags",  "placeholders",  ]
    
    end

    def self.ci_array_properties
    
      nil
    
    end
  end

      