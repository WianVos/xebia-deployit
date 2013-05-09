#!/usr/bin/ruby
require 'net/http'
require 'rubygems'
require 'xmlsimple'
require 'rest_client'

class Deployit
  def initialize
    @username = 'admin'
    @password = 'admin'
    @protocol = 'http'
    @url_prefix = "/deployit/repository"
    @host = "localhost"
    @port = "4516"
    if @username != nil and @password != nil
      @base_url="#{@protocol}://#{@username}:#{@password}@#{@host}:#{@port}#{@url_prefix}"
    else
      @base_url="#{@protocol}://#{@host}:#{@port}#{@url_prefix}"
    end
  end

  def get_ci_list(type)
    @ref_list = []
    xml = RestClient.get "#{@base_url}/query", {:params => { :type => "#{type}"}, :accept => :xml, :content_type => :xml}
    hash = XmlSimple.xml_in(xml)
    hash["ci"].each {|item|
      @ref_list << item["ref"]
    }
    return @ref_list
  end

  def get_ci(ref)
    p ref
    xml = RestClient.get "#{@base_url}/ci/#{ref}", {:accept => :xml, :content_type => :xml}
    return XmlSimple.xml_in(xml)
  end

  def get_detail_list(type)
    ref_list = get_ci_list(type)
    ref_list.each {|ref|
      p get_ci(ref)
    }
  end
  def add_ci()
    hash={ "password" => "test123",
           "username" => "admin",
           "address" => "192.168.0.1",
           "connectionType" => "SUDO",
           "os" => "UNIX"}
     xml = XmlSimple.xml_in(hash)
     p xml
        
  end
  
end

workitem = {
  :fqdn => "localhost"
}

deployit_host = {
  :os       => 'UNIX',
  :address  => workitem[:fqdn],
  :username => 'deployit'
}

d = Deployit.new
#p d.get_list("overthere.SshHost")
#p d.get_detail_list("overthere.SshHost")
d.add_ci