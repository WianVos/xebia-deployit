require 'rubygems'
require 'pathname'
# copied in ruby libs
#require 'xml-simple'
require 'restclient' if Puppet.features.restclient?
require 'xmlsimple' if Puppet.features.restclient?

#require File.expand_path('../lib/xmlsimple.rb', __FILE__)
#require File.expand_path('../lib/rest_client.rb', __FILE__)


module Puppet
module Deployit_util

class Ci
  def initialize(username,password,protocol="http",host="localhost",port="4516")
     @username = username
     @password = password
     @protocol = protocol
     @host = host
     @port = port
     
     @url_prefix = "/deployit/repository"
     @base_url="#{@protocol}://#{@username}:#{@password}@#{@host}:#{@port}#{@url_prefix}"
     
   end
   
   def get_ci(id)
      xml = RestClient.get "#{@base_url}/ci/#{id}", {:accept => :xml, :content_type => :xml}
      return XmlSimple.xml_in(xml)
   end
  
   def ci_exists?(id)
      xml = RestClient.get "#{@base_url}/exists/#{id}", {:accept => :xml, :content_type => :xml }
      return true if XmlSimple.xml_in(xml) == "true"    
      return false
   end
   
  def add_ci(id, type, props={}, create_path=false )
      
      unless directory_exists?(id)
            add_directory(Pathname.new(id).dirname)
      end
      
      xml = to_deployit_xml(type, props, id) 
      response = RestClient.post "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
        
   end
  
   def delete_ci(id)
      response = RestClient.delete "#{@base_url}/ci/#{id}"
   end
   
   def match_property_hash(id, fields=[])
     
     @output_props = {}
       
     props = get_ci(id)
     
     fields.each { |f| 
        @output_props[f] = props[f]
     }
     return @output_props
     
   end
  
   def modify_ci(id,type,props)
    
       new_props = get_ci(id).merge(props)
    
       xml = to_deployit_xml(type, new_props, id)
       
       response = RestClient.put "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
    
   end
   
   def get_ci_property_hash(id)
      new_props = get_ci(id)
      return clean_property_hash(new_props)
   end
   
   private
   
   def add_directory(id)
      props = { '@id' => id}
      add_ci("#{id}","core.Directory", props)
   end
    
   def directory_exists?(id)
      path = Pathname.new(id).dirname
      ci_exists?(path)
   end
   
  def to_deployit_xml( type, props , id)
     props = {} unless props != nil
     props['id'] = id unless id == nil
     props['@id'] = props['id'] if props.has_key?('id')
     props['@token'] = props['token'] if props.has_key?('token')
         
         
     props.delete('id') if props.has_key?('id')
     props.delete('token') if props.has_key?('token')
         
     xml = XmlSimple.xml_out(props, :RootName => type ,:AttrPrefix => true ) 
     
   end
   
   def clean_property_hash(props)
     props.delete('id') if props.has_key?('id')
     props.delete('token') if props.has_key?('token')
     return props
   end
   
  
   
end
end
end
