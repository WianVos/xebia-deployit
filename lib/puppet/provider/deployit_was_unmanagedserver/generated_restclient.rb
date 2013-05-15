
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_was_unmanagedserver).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "was.UnmanagedServer"
    end

    def self.properties
    
      [  "cellName",  "password",  "version",  "wasHome",  "username",  "nodeName",  ]
    
    end

    def self.parent
    
      [  "core.Directory",  "overthere.Host",  "overthere.SshHost",  "overthere.CifsHost",  ]
    
    end

    def self.autorequires
    
      [  "deployit_core_directory",  "deployit_overthere_host",  "deployit_overthere_sshhost",  "deployit_overthere_cifshost",  ]
    

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

      