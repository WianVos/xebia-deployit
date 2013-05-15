require 'erb'
require 'rubygems'
require 'pathname'
require 'fileutils'
require 'xmlsimple'

module Genres
  class DeployitMetaXml
    def initialize(file=nil,selector="")
      @file = file
      @selector = selector
      @types_hash = to_hash(read_file(@file))
      @res_array = @types_hash.first.last
      @res_hash = {}
      @res_array.each do |x|
      @res_hash["#{x['type']}"] = x if x["type"] =~ /#{selector}/
      end
      #
  
    end
  
    def to_hash(xml)
  
      return XmlSimple.xml_in(xml)
    end
  
    def to_xml(hash)
      return XmlSimple.xml_out(hash)
    end
  
    def read_file(file)
      File.read(file)
    end
  
    def get_types_list(selector=@selector)
  
      @res_hash.keys
  
    end
  
    def get_properties(type,kind="")
      result = {}
      if @res_hash[type]['property-descriptors'].first['property-descriptor'] != nil
        @res_hash[type]['property-descriptors'].first['property-descriptor'].each {|x| result["#{x['name']}"] = x if x['kind'] == kind and x['hidden'] != "true"}
      end
  
      return result
    end
  
    def get_parents(type)
      result = []
      result << @res_hash[type]['containerType'] unless @res_hash[type]['containerType'] == nil
      result.concat ["core.Directory"]
      result.concat get_properties(type,kind="CI")["host"]["referencedType"] unless get_properties(type,kind="CI").has_key?('host') == false
      result.concat ["overthere.SshHost","overthere.CifsHost"] if result.include? "overthere.Host"
      return result
    end
  
    def get_property_names(type,kind)
      get_properties(type,kind).keys
    end
  end

end