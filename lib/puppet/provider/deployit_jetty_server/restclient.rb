require File.expand_path('../../general_restclient.rb', __FILE__)

Puppet::Type.type(:deployit_jetty_server).provide(:restclient, :parent => Puppet::Provider::General_restclient) do

#  confine :feature => :restclient
 
  def initialize(value)
    super(value)
    @deployit_type = self.class.deployit_type
    @properties = self.class.properties
    @parent = self.class.parent
    @complex_props = self.class.complex_tags
    @array_properties = self.class.simple_array_properties
    p "test"
  end
  
#  def tags
#    result = nil
#    if @property_hash.has_key?("tags")
#      result = @property_hash["tags"].first['value']
#      
#      result.shift if result != nil and result.first.is_a?(Hash)
#      
#    end
#    # check if the result is not nil
#   
#    p result
#    return result
#  end
#  
#  def tags=(value)
#    p value
#    @property_hash["tags"] = {'values' => value }
#    
#  end
  def self.deployit_type
    "jetty.Server"
  end

  def self.properties
    ["home"]
  end

  def self.parent
    ["overthere.SshHost"] 
  end
  
  def self.complex_tags
    ["envvars"]
  end
  
  def self.simple_array_properties
    ["tags"]
  end


end
#"tags"=>[{"value"=>[{}, "shit zeg", "lullo", "test"]}], "host"=>[{"ref"=>"Infrastructure/Test1/TestJetty11"}], "id"=>"Infrastructure/Test1/TestJetty11/test1", "envVars"=>[{"entry"=>[{"key"=>"owner", "content"=>"root"}, {"key"=>"schiet", "content"=>"niet op dit"}, {"key"=>"group", "content"=>"root"}]}], "token"=>"8b7ae506-fd18-43c7-aaaa-ae1809ffe37a", "home"=>["/home/home"]}
