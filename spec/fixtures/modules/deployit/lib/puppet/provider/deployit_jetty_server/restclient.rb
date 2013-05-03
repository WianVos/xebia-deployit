require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_jetty_server).provide(:restclient, :parent => Puppet::Provider::General_restclient) do
  #  confine :feature => :restclient
  def initialize(value)
    super(value)
    @deployit_type = self.class.deployit_type
    @properties = self.class.properties
    @parent = self.class.parent
    @hash_properties = self.class.hash_properties
    @array_properties = self.class.array_properties
  end

  def self.deployit_type
    "jetty.Server"
  end

  def self.properties
    ["home"]
  end

  def self.parent
    ["overthere.SshHost"]
  end

  def self.autorequires
    ["deployit_core_directory","deployit_overthere_ssh_host"]
  end

  def self.hash_properties
    ["envVars"]
  end

  def self.array_properties
    ["tags"]
  end

end
