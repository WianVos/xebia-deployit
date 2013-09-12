require File.expand_path('../../../deployit_util/ci.rb', __FILE__) if RUBY_VERSION < '1.9.0' && Puppet.features.restclient?



Puppet::Type.type(:deployit_ci).provide(:ruby) do
  
  confine :feature => :restclient
  
  def create
    
    props = {}
    props = resource[:properties].first unless resource[:properties] == nil
      
    c = Puppet::Deployit_util::Ci.new(resource[:username], resource[:password], resource[:protocol], resource[:host], resource[:port])
    c.add_ci(resource[:id], resource[:type], props )
        
  end
  
  def destroy
    c = Puppet::Deployit_util::Ci.new(resource[:username], resource[:password], resource[:protocol], resource[:host], resource[:port])
    c.delete_ci(resource[:id])  
  end
  
  def exists?
    c = Puppet::Deployit_util::Ci.new(resource[:username], resource[:password], resource[:protocol], resource[:host], resource[:port])
    c.ci_exists?(resource[:id])
  end
  
  def properties
    c = Puppet::Deployit_util::Ci.new(resource[:username], resource[:password], resource[:protocol], resource[:host], resource[:port])
    c.get_ci_property_hash(resource[:id])
  end
  
  def properties=(value)
    c = Puppet::Deployit_util::Ci.new(resource[:username], resource[:password], resource[:protocol], resource[:host], resource[:port])
    c.modify_ci(resource[:id], resource[:type], value.first)
  end

end
