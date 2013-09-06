#!/usr/bin/env /opt/puppet/bin/ruby
require 'rubygems'
require 'rest_client'

@username = ARGV[1]
@password = ARGV[2]
@protocol = "http"
@host = ARGV[0]
@port = "4516"
@url_prefix = "/deployit"
@xml_file_name = "rest.xml"

@base_url="#{@protocol}://#{@username}:#{@password}@#{@host}:#{@port}#{@url_prefix}"
p @deployit_server

xml = RestClient.get "#{@base_url}/metadata/type", {:accept => :xml, :content_type => :xml}

xml_file = File.new(@xml_file_name, "w")
xml_file.write(xml)
xml_file.close
