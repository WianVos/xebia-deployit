require 'rubygems' if  Puppet.features.restclient?
require 'pathname' if  Puppet.features.restclient?
require 'restclient' if  Puppet.features.restclient?

require 'xmlsimple'  if  Puppet.features.restclient?

module Puppet
  module Deployit_util
    class Ci
      def initialize(username,password,protocol="http",host="localhost",port="4516",url_prefix="/deployit/repository")
        @username = username
        @password = password
        @protocol = protocol
        @host = host
        @port = port
        @debug = false

        @url_prefix = url_prefix
        @base_url="#{@protocol}://#{@username}:#{@password}@#{@host}:#{@port}#{@url_prefix}"

      end

      # get the ci and its properties
      # returns a hash with the key value pairs
      def get_ci(id)
        xml = RestClient.get "#{@base_url}/ci/#{id}", {:accept => :xml, :content_type => :xml}
        return XmlSimple.xml_in(xml)
      end

      # does the ci exits ? True if it does .. false if it doesn't
      def ci_exists?(id)
        p __method__ if @debug == true
        xml = RestClient.get "#{@base_url}/exists/#{id}", {:accept => :xml, :content_type => :xml }
        return true if XmlSimple.xml_in(xml) == "true"
        return false
      end

      # add_ci creates a ci in the deployit inventory. We will take care of creating the undelying directory's but not other types because the get more complicated
      # these can be added from puppet itself by using the normal resource classes
      def add_ci(id, type, props={}, parent = ["core.Directory", "internal.Root"])
          p __method__ if @debug == true

        # if type is a directory lets create te full path for it
        #if type == "core.Directory"
          add_parent_directory(id) unless parent_exists?(id)
          # create the xml body
          xml = to_deployit_xml(type, props, id)
          # push the xml to the correct xml
          response = RestClient.post "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
          # return our success
          return "succes"
        #else

          # if the ci is created on top of an illegal parent type .. let's go bonckers
        #  return "invalid parent type for #{id}" unless parent_correct?(id,parent)
          # create the xml body
        #  xml = to_deployit_xml(type, props, id)
          # push the xml to the correct xml

         # response = RestClient.post "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
          # return our success
          #return "succes"
        #end
      end

      # delete the ci
      def delete_ci(id)
       p __method__ if @debug == true

        response = RestClient.delete "#{@base_url}/ci/#{id}"
      end

      def match_property_hash(id, fields=[])
       p __method__ if @debug == true

        @output_props = {}

        props = get_ci(id)

        fields.each { |f|
          @output_props[f] = props[f]
        }
        return @output_props

      end

      def modify_ci(id,type,props)
       p __method__ if @debug == true

        new_props = get_ci(id).merge(props)
        xml = to_deployit_xml(type, new_props, id)
        response = RestClient.put "#{@base_url}/ci/#{id}", xml, {:content_type => :xml}
      end

      def get_ci_property_hash(id)
       p __method__ if @debug == true

        new_props = get_ci(id)
        return clean_property_hash(new_props)
      end

      def get_ci_hash(id)
       p __method__ if @debug == true

        new_props = get_ci(id)
        return new_props
      end

      def modify_ci_prop(id,key,value)
       p __method__ if @debug == true

        props[key] = value
        xml
      end
      private

      def add_directory(id)
       p __method__ if @debug == true

        props = { '@id' => id}
        add_ci("#{id}","core.Directory", props)
      end

      def parent_exists?(id)
       p __method__ if @debug == true

        path = Pathname.new(id).dirname
        ci_exists?(path)
      end

      # check if the parent type of the suggested ci is correct
      def parent_correct?(id,parent)
       p __method__ if @debug == true

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
       p __method__ if @debug == true

        props = {} unless props != nil
        props['id'] = id unless id == nil
        props['@id'] = props['id'] if props.has_key?('id')
        props['@token'] = props['token'] if props.has_key?('token')

        # if the hash contains envvars than we should mangle the hash a little bit
        # to properly translate to a valid xml that deployit understands the key should be named @key and not key
        p "envvars" if @debug == true
        if props.has_key?('envVars') == true 
          if  props['envVars'].first.has_key?('entry') == true 
            if props['envVars'].first['entry'].first.has_key?('key') == true
           result = {}
           props['envVars'].first['entry'].each {|d| result[d['key']] = d['content']} if props['envVars'].first.has_key?('entry')
           props['envVars'] = [{ 'entry' => []}]
           result.each {|key, value| props['envVars'].first['entry'] << { "content" => value,  "@key" => key } }
          end
        end
      end
      p "members" if @debug == true
        if props.has_key?('members') == true 
         if props['members'].first.has_key?("ci") == true 
          if props['members'].first['ci'].first.has_key?('ref')   
          result = []
          props["members"].first["ci"].each {|ci| result << ci['ref'] }
          props["members"] = [{'ci' => [] }]
          result.each {|v| props['members'].first['ci'] << { "@ref" => v } }
          end
         end
        end
        p "dicts" if @debug == true
        if props.has_key?('dictionaries') == true  
          if props['dictionaries'].first.has_key?('ci') == true
            if props['dictionaries'].first['ci'].first.has_key?('ref')
             result = []
             props["dictionaries"].first["ci"].each {|ci| result << ci['ref'] }
             props["dictionaries"] = [{'ci' => [] }]
             result.each {|v| props['dictionaries'].first['ci'] << { "@ref" => v } }
           end
          end
        end

        props.delete('id') if props.has_key?('id')
        props.delete('token') if props.has_key?('token')
        props.delete('host') if props.has_key?('host')
        props.delete('parent') if props.has_key?('parent')
        xml = XmlSimple.xml_out(props, :RootName => type ,:AttrPrefix => true )
      end

      def clean_property_hash(props)
       p __method__ if @debug == true

        props.delete('id') if props.has_key?('id')
        props.delete('token') if props.has_key?('token')
        return props
      end

      def add_directory(id)
       p __method__ if @debug == true

        props = { '@id' => id}
        add_ci("#{id}","core.Directory", props)
      end

      def add_parent_directory(id)
       p __method__ if @debug == true

        path = Pathname.new(id).dirname
        props = { '@id' => path }
        add_ci("#{path}","core.Directory", props)
      end

      def parent_exists?(id)
       p __method__ if @debug == true

        path = Pathname.new(id).dirname
        ci_exists?(path)
      end

    end
  end
end
