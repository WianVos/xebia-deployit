require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_udm_environment).provide(:restclient, :parent => Puppet::Provider::General_restclient) do
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
    "udm.Environment"
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
   nil
  end

  def self.array_properties
    nil  
  end
  def self.ci_array_properties
    ["members"]
  end

  def members
    result = []
#    p @property_hash
#    p @property_hash["members"]
#    p @property_hash["members"].first["ci"]
    @property_hash["members"].first["ci"].each do |ci|
      result << ci["ref"]
    end
    return result   
  end
  
  def members=(value)
    @property_hash['members'] = [{ 'ci' => []}]
    value.each {|v| @property_hash['members'].first['ci'] << { "@ref" => v } }
    p @property_hash
      
  end
end