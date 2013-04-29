#!/usr/bin/ruby
require 'net/http'
require 'rubygems'
require 'xmlsimple'
require 'rest_client'
require 'pathname'

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
  
  def add_overthereHost(id,password,username,address,connectiontype,os)
      p id
      props = { '@id' => id,
        "password" => password,
        "username" => username,
        "address" => address,
        "connectionType" => connectiontype,
        "os" => os}
      
      unless directory_exists?(id)
        add_directory(Pathname.new(id).dirname)
      end
      
      add_ci("#{id}","overthere.SshHost", props)
      
  end
  
  def add_directory(id)
    props = { '@id' => id}
    add_ci("#{id}","core.Directory", props)
  end
  
  def directory_exists?(id)
    path = Pathname.new(id).dirname
    ci_exists?(path)
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

  def ci_exists?(ref)
    xml = RestClient.get "#{@base_url}/exists/#{ref}", {:accept => :xml, :content_type => :xml }
    return true if XmlSimple.xml_in(xml) == "true"    
    return false
  end
  
  def get_detail_list(type)
    ref_list = get_ci_list(type)
    ref_list.each {|ref|
      p get_ci(ref)
    }
  end

  def add_ci(id , type, props)
    xml = XmlSimple.xml_out(props, :RootName => type ,:AttrPrefix => true )
    response = RestClient.post "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
    p response
  end

  def delete_ci(id)
    response = RestClient.delete "#{@base_url}/ci/#{id}"
    p response
  end

  def modify_ci(id,type,props)
  
      new_props = get_ci(id).merge(props)
  
      new_props['@id'] = new_props['id']
      new_props['@token'] = new_props['token']
  
  
      new_props.delete('id')
      new_props.delete('token')
  
      xml = XmlSimple.xml_out(new_props, :RootName => type ,:AttrPrefix => true )
      response = RestClient.put "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
  
    end
  
  
  def delete_all(type)
    get_ci_list(type).each {|ci| delete_ci(ci) }
    
  end
  def type_exists?(type)
    
  end

end

d = Deployit.new
#d.add_overthereHost("Infrastructure/testIII/TestHost3", "admin", "admin", "192.168.1.2", "SUDO", "UNIX")
#d.get_detail_list("overthere.SshHost")
#d.delete_ci("Infrastrucuture/TestHost3")
#d.get_detail_list("overthere.SshHost")
#d.delete_all("overthere.SshHost")
#p d.ci_exists?("Infrastructure/test")
d.modify_ci("Infrastructure/testIII/TestHost3", "overthere.SshHost", {"address" => "192.168.1.3"} )
  