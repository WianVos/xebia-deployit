require File.expand_path('../../../deployit_util/ci.rb', __FILE__)



class Puppet::Provider::General_ci < Puppet::Provider
  
  confine :feature => :restclient
  
  def initialize
    @type = self.type
    @properties = self.properties
  end
  
  def create_deployit_connection
    Puppet::Deployit_util::Ci.new(resource[:username], resource[:password], resource[:protocol], resource[:host], resource[:port])
  end
  def create
    
    props = {}
    props = resource[:properties].first unless resource[:properties] == nil
      
    c = create_deployit_connection
    c.add_ci(resource[:id], resource[:type], props )
        
  end
  
  def destroy
    c = create_deployit_connection
    c.delete_ci(resource[:id])  
  end
  
  def exists?
    c = create_deployit_connection
    c.ci_exists?(resource[:id])
  end
  
  def properties
    c = create_deployit_connection
    c.get_ci_property_hash(resource[:id])
  end
  
  def properties=(value)
    c = create_deployit_connection
    c.modify_ci(resource[:id], resource[:type], value.first)
  end

end
