require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_overthere_ssh_host).provide(:restclient, :parent => Puppet::Provider::General_restclient) do

#  confine :feature => :restclient
 
  def initialize(value)
    super(value)
    @deployit_type = self.class.deployit_type
    @properties = self.class.properties
    @parent = self.class.parent
    @array_properties = self.class.array_properties
    @hash_properties = self.class.hash_properties
  end
  
  
  def self.deployit_type
    "overthere.SshHost"
  end

  def self.properties
    ["os","connectionType","username","password","port","address","tags"]
  end

  def self.parent
    ["internal.Root", "core.Directory"] 
  end

  def self.hash_properties
     ["envVars"]
   end
   
   def self.array_properties
     ["tags"]
   end
end

