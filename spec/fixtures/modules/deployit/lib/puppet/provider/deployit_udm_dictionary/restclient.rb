require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_udm_dictionary).provide(:restclient, :parent => Puppet::Provider::General_restclient) do
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
    "udm.Dictionary"
  end

  def self.properties
    nil
  end

  def self.parent
    ["core.Directory"]
  end

  def self.autorequires
    ["deployit_core_directory"]
  end

  def self.hash_properties
    ["entries"]
  end

  def self.array_properties
    nil  
  end
  def self.ci_array_properties
      nil
    end
end