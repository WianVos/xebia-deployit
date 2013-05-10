
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_was_unmanagedserver).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "was.UnmanagedServer"
    end

    def self.properties
    
      [  "nodeName",  "cellName",  "username",  "password",  "wasHome",  ]
    
    end

    def self.parent
    
      [  "overthere.Host",  "overthere.Ssh_Host",  "overthere.Cifs_Host",  ]
    
    end

    def self.autorequires
    
      [  "deployit_overthere_host",  "deployit_overthere_ssh_host",  "deployit_overthere_cifs_host",  ]
    

    end

    def self.hash_properties
    
      nil
    
    end

    def self.array_properties
    
      [  "tags",  "webServers",  ]
    
    end

    def self.ci_array_properties
    
       [  "webServers",  ]
    
    end
  end

      