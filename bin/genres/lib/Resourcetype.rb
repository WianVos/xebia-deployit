require 'erb'
require 'rubygems'
require 'pathname'
require 'fileutils'
require 'xmlsimple'

module Genres
  class ResourceType
    include ERB::Util
    def initialize(deployit_resource,parents=nil,string_props=nil,array_props=nil,hash_props=nil,ci_array_props=nil,basedir="/etc/puppetlabs/puppet/modules/deployit")

      @puppet_resource_name = "deployit_" + deployit_resource.downcase.gsub('.','_')
      @target_dir = "#{basedir}/lib/type/generated"
      @target_file = "#{@target_dir}/#{@puppet_resource_name}.rb"
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
      resultstring << ERB.new(header()).result(binding)
      @string_props.each  {|prop| resultstring <<  ERB.new(string_property(prop)).result(binding) } unless @string_props == nil
      @array_props.each  {|prop| resultstring <<  ERB.new(array_property(name=prop)).result(binding) } unless @array_props == nil
      @hash_props.each {|prop| resultstring <<  ERB.new(hash_property(name=prop)).result(binding) } unless @hash_props == nil
      @ci_array_props.each {|prop| resultstring <<  ERB.new(array_property(name=prop)).result(binding) } unless @ci_array_props == nil
      resultstring << ERB.new(auto_requires(autorequire_resources=@autorequire_resources)).result(binding)  unless @autorequire_resources == nil
      resultstring << ERB.new(footer()).result(binding)
      return resultstring
    end

    def header()
      %{Puppet::Type.newtype(:<%= @puppet_resource_name %> ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a <%= @puppet_resource_name %> ci to a remote deployit server'

      ensurable do

        desc 'deployit <%= @puppet_resource_name %> resource state'

        defaultto(:present)

        newvalue(:present) do

          provider.create

        end

        newvalue(:absent) do

          provider.destroy

        end

      end

      # name var
      newparam(:id, :namevar => true) do
        desc '<%= @puppet_resource_name %> id (full path required)'

        validate do |value|
              fail("invalid id") unless value =~ /^(Infrastructure|Environments)/
         end
      end

      # general properties (default deployit stuff)

      newparam(:deployit_username) do
        desc 'a valid deployit user'
        defaultto('admin')
      end

      newparam(:deployit_password) do
        desc 'the password for the deployit user'
        defaultto('admin')
      end

      newparam(:deployit_host) do
        desc 'address of the deployit server'
        defaultto('localhost')
      end

      newparam(:deployit_port) do
        desc 'port to reach the deployit server on'
        defaultto('4516')
      end

      newparam(:deployit_protocol) do
        desc 'protocol to use in communication to the deployit host'
        defaultto('http')
      end
    }
    end

    def string_property(prop)
      p prop
      if prop.class == Array
        %{
      newproperty(:<%= prop.first.to_s.downcase %>) do
        <% if prop.last.has_key? 'label' %> 
          desc '<%= prop.last['label'] %>'
        <%end%>
        <% if prop.last.has_key? 'default' %> 
          defaultto ('<%= prop.last['default'] %>') 
        <%end%>
        <% if prop.last['required'] == 'true' and  prop.last.has_key?('default') == false %>
          defaultto('unset')
        <% end %>   
        <% if prop.last['required'] == 'true' %> 
          validate do |value|
            unless value != 'unset'
              fail('<%= prop.first.to_s.downcase %> needs to be set')
            end
          end
        <% end %>
      end
    }
      else
        %{
        newproperty(:<%= prop.downcase %>) do
             end
        }
      end
    end

    def array_property(name)
      %{
      newproperty(:<%= name.downcase %> , :array_matching => :all) do
        def insync?(is)

          # Comparison of Array's
          # if either the should or the is (which we get from the providers envvars method is not a hash we'll fail
          return false unless is.class == Array and should.class == Array

          # now lets compare the two and see is a modify is needed
          # haven't quite worked out yet what to do with extra values in the is hash
          @should.each do |k|

            # if is[k] is not equal to should[k] the insync? should return false
            return false unless is.include?(k)

          end
          return false unless is.length == @should.length
          true
        end

      end
  }
    end

    def hash_property(name)
      %{
      newproperty(:<%= name.downcase %> , :array_matching => :all) do

          desc 'a hash of valid propertys to be sent to deployit'

          # validate that where actually sending a hash
          validate do |value|
            raise ArgumentError, "Puppet::Type::deployit_jetty_server: envvars must be a hash." unless value.is_a? Hash
          end

          #overwrite the default insync? method completely
          def insync?(is)
            # @should is an Array. see lib/puppet/type.rb insync?
            # the hash where interested in is in the first field of the @should array
            # this holds the hash we assigend to envvars
            should = @should.first
            # Comparison of hashes
            # if either the should or the is (which we get from the providers envvars method is not a hash we'll fail
            return false unless is.class == Hash and should.class == Hash

            # now lets compare the two and see is a modify is needed
            # haven't quite worked out yet what to do with extra values in the is hash
            should.each do |k,v|

              # if is[k] is not equal to should[k] the insync? should return false
              return false unless is[k].to_s == should[k].to_s

            end
            true
          end

          def should_to_s(newvalue)
            # Newvalue is an array, but we're only interested in first record.
            newvalue = newvalue.first
            newvalue.inspect
          end

          def is_to_s(currentvalue)
            currentvalue.inspect
          end
        end
        }
    end

    def auto_requires(autorequire_resources)
      %{
      <% if autorequire_resources.any? %>
      # autorequire all the deployit_core_directory resources
      [<% autorequire_resources.each {|res| %> "<%= res %>", <% }  %>].each {|c|
        autorequire(c.to_sym) do
          requires = []
          catalog.resources.each {|d|
            if (d.class.to_s == "Puppet::Type::\#{c.capitalize}")
              requires << d.name
            end
          }

          requires
        end
      }
    <% end %>
      }
    end

    def footer()
      %{
    end
    }
    end

  end
end
