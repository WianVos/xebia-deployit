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

      # add_ci creates a ci in the deployit inventory. We will take care of creating the undelying directory's but not other types because the get more complicated
      # these can be added from puppet itself by using the normal resource classes
      def add_ci(id, type, props={}, parent = ["core.Directory", "internal.Root"])
        p id
        p type
        p props
        p parent
        
        # if where adding a directory .. just add it without looking at the parents
        if type == "core.Directory"
          add_directory(Pathname.new(id).dirname) unless parent_exists?(id)
        else

          # if where adding something else do the valid parent check
          add_directory(Pathname.new(id).dirname) unless parent_exists?(id) or parent.include? "core.Directory"

          if parent != nil

            # if the ci is created on top of an illegal parent type .. let's go bonckers
            p parent_correct?(id,parent)
            return "invalid parent type for #{id}" unless parent_correct?(id,parent)
          end
        end

        # create the xml body
        xml = to_deployit_xml(type, props, id)
        p xml
        # push the xml to the correct xml
        response = RestClient.post "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
        p response
        # return our success
        return "succes"

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

      def get_ci_hash(id)
        new_props = get_ci(id)
        return new_props
      end

      def modify_ci_prop(id,key,value)
        props[key] = value
        xml
      end
      private

      def add_directory(id)
        props = { '@id' => id}
        add_ci("#{id}","core.Directory", props)
      end

      def parent_exists?(id)
        path = Pathname.new(id).dirname
        ci_exists?(path)
      end

      # check if the parent type of the suggested ci is correct
      def parent_correct?(id,parent)

        # get the suggested pathname .. using the pathname library here.
        path = Pathname.new(id).dirname

        # get the parent ci from the rest interface
        xml = RestClient.get "#{@base_url}/ci/#{path}", {:accept => :xml, :content_type => :xml}

        # get the parent type from the xml
        parenttype = XmlSimple.xml_in(xml,{'KeepRoot' => true}).keys.to_s
        # check if the actual parenttype is among the valid ones
        return true if parent.include? parenttype

        return false
      end

      def to_deployit_xml( type, props , id)
        props = {} unless props != nil
        props['id'] = id unless id == nil
        props['@id'] = props['id'] if props.has_key?('id')
        props['@token'] = props['token'] if props.has_key?('token')

        props.delete('id') if props.has_key?('id')
        props.delete('token') if props.has_key?('token')
        props.delete('host') if props.has_key?('host')
        
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
