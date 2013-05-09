require 'erb'
require 'rubygems'
require 'pathname'
require 'fileutils'
require 'xmlsimple'

module Genres
  class ResourceProvider
    def initialize(deployit_resource,parents=nil,string_props=nil,array_props=nil,hash_props=nil,ci_array_props=nil,basedir="/tmp/output/")
      @deployit_resource = deployit_resource
      @puppet_resource_name = "deployit_" + deployit_resource.downcase.gsub('.','_')
      @target_dir = "#{basedir}/lib/provider/#{@puppet_resource_name}"
      @target_file = "#{@target_dir}/restclient.rb"
      @deployit_resource = deployit_resource
      @string_props = string_props
      @array_props = array_props
      @hash_props = hash_props
      @ci_array_props = ci_array_props
      @parents = parents
      @autorequire_resources = []
      @parents.each  do  |parent|
        @autorequire_resources << "deployit_" + parent.downcase.gsub('.','_')
      end
  
    end
  
    def create_path(path=@target_dir)
  
      FileUtils.mkpath path
  
    end
  
    def write_file(local_file=@target_file)
      create_path
      outfile = File.open(local_file, 'w')
      outfile << write_document()
    end
  
    def write_document()
      resultstring = ""
      resultstring << ERB.new(provider()).result(binding)
      return resultstring
    end
  
    def provider()
      %{
      require File.expand_path('../../general_restclient.rb', __FILE__)
  
      Puppet::Type.type(:<%= @puppet_resource_name %>).provide(:restclient, :parent => Puppet::Provider::General_restclient) do
        #this type is generated with genres
        #  confine :feature => :restclient
        def initialize(value)
          super(value)
          @deployit_type = self.class.deployit_type
          @properties = self.class.properties
          @parent = self.class.parent
          @array_properties = self.class.array_properties
          @hash_properties = self.class.hash_properties
        end
  
        def self.deployit_type
          "<%= @deployit_resource %>"
        end
  
        def self.properties
        <% if @string_props.any? %>
          [ <% @string_props.each {|s| %> "<%= s %>", <% }  %> ]
        <% else %>
          <%= "nil" %>
        <% end %>
        end
  
        def self.parent
        <% if @parents.any? %>
          [ <% @parents.each {|s| %> "<%= s %>", <% }  %> ]
        <% else %>
           <%= "nil" %>
        <% end %>
        end
  
        def self.autorequires
        <% if @autorequire_resources.any? %>
          [ <% @autorequire_resources.each {|s| %> "<%= s %>", <% }  %> ]
        <% else %>
          <%= "nil" %>
        <% end %>
  
        end
  
        def self.hash_properties
        <% if @hash_props.any? %>
          [ <% @hash_props.each {|s| %> "<%= s %>", <% }  %> ]
        <% else %>
          <%= "nil" %>
        <% end %>
        end
  
        def self.array_properties
        <% if @array_props.any? %>
          [ <% @array_props.each {|s| %> "<%= s %>", <% }  %> ]
        <% else %>
           <%= "nil" %>
        <% end %>
        end
  
        def self.ci_array_properties
        <% if @ci_array_props.any? %>
           [ <% @ci_array_props.each {|s| %> "<%= s %>", <% }  %> ]
        <% else %>
          <%= "nil" %>
        <% end %>
        end
      end
  
      }
    end
  end
end