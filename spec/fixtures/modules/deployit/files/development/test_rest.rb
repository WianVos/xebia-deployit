#!/usr/bin/ruby
require 'net/http'
require 'rubygems'
require 'xmlsimple'
require 'cgi'

class Deployit
  def initialize
    @host     = 'http://localhost:4516/deployit/repository/'
    @username = 'admin'
    @password = 'admin'
  end

  def create(id, type, props)
    props['@id'] = id
    xml = XmlSimple.xml_out(props, :RootName => type, :AttrPrefix => true)
    uri = URI(@host+ "ci/" + id)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.basic_auth @username, @password
    req['Content-Type'] = 'application/xml'
    req.body = xml
    response = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(req)
    }
    response
  end

  def http_get(domain,path,params)
    p domain
    return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
    return Net::HTTP.get(domain, path)
  end

#  def list(type)
#   uri = URI(@host + "query/")
#   req = Net::HTTP::Get.new(uri.request_uri + '/)
#   req.basic_auth @username, @password
#   req['Content-Type'] = 'application/xml'
#   response = Net::HTTP.start(uri.host, uri.port) {|http|
#      http.request(req)
#    }
#   end
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
res = d.create('Infrastructure/' + deployit_host[:address], 'overthere.SshHost', deployit_host)
puts res.code + " - " + res.message
puts res.body
#params = {:q => "ruby", :max => 50}
#p d.http_get("www.example.com", "/search.cgi", params)