#!/opt/puppet/bin/ruby
require 'rubygems'
require 'pathname'
require 'restclient'

require 'xmlsimple'
@username="admin"
@password = "admin"
@protocol = "http"
@host = "localhost"
@port = "4516"

@url_prefix = "/deployit"
@base_url="#{@protocol}://#{@username}:#{@password}@#{@host}:#{@port}#{@url_prefix}"



def get_roles_hash
  xml = RestClient.get "#{@base_url}/security/role", {:accept => :xml, :content_type => :xml}
  return XmlSimple.xml_in(xml)
end

def add_role(rolename)
  xml = ""
  response = RestClient.put "#{@base_url}/security/role/#{rolename}", xml, {:content_type => :xml}
end
def role_exists(rolename)
  return true if get_roles_hash["string"].include? rolename
  return false
end
def delete_role(rolename)
  response = RestClient.delete "#{@base_url}/security/role/#{rolename}"
end

p add_role("thijsv")
p get_roles_hash
p role_exists("thijsv")
p delete_role("thijsv")
p role_exists("thijsv")
p get_roles_hash