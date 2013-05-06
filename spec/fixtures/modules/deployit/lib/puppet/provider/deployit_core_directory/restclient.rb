require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_core_directory).provide(:restclient, :parent => Puppet::Provider::General_restclient) do
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
    "core.Directory"
  end

  def self.properties
  end

  def self.parent
    ["internal.Root"]
  end

  def self.hash_properties

  end

  def self.array_properties

  end

  def self.ci_array_properties
    nil
  end

end
