
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_wls_domain).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "wls.Domain"
    end

    def self.properties
    
      [  "domainHome",  "password",  "protocol",  "version",  "adminServerName",  "startMode",  "wlHome",  "wlstPath",  "username",  ]
    
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
    
      [  "tags",  "clusters",  "servers",  ]
    
    end

    def self.ci_array_properties
    
       [  "clusters",  "servers",  ]
    
    end
  end

      