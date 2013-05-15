
require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_file_deployedfile).provide(:generated_restclient, :parent => Puppet::Provider::General_restclient) do
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
      "file.DeployedFile"
    end

    def self.properties
    
      [  "targetFileName",  "targetPath",  ]
    
    end

    def self.parent
    
      [  "overthere.Host",  "core.Directory",  "overthere.SshHost",  "overthere.CifsHost",  ]
    
    end

    def self.autorequires
    
      [  "deployit_overthere_host",  "deployit_core_directory",  "deployit_overthere_sshhost",  "deployit_overthere_cifshost",  ]
    

    end

    def self.hash_properties
    
      [  "placeholders",  ]
    
    end

    def self.array_properties
    
       nil
    
    end

    def self.ci_array_properties
    
      nil
    
    end
  end

      