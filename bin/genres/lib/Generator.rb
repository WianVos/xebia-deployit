require './lib/Resourceprovider.rb'
require './lib/ResourceType.rb'
require './lib/DeployitMetaXml.rb'

module Genres
  class Generator
    def initialize(file,selector)
      @file = file
      @selector = selector
    end
    
    def do
      x = Genres::DeployitMetaXml.new(file=@file,selector=@selector)
      x.get_types_list.each do |r|

        lparents = x.get_parents(r)
        lstrings = x.get_property_names(r,"STRING")
        lstrings.concat x.get_property_names(r,"ENUM")
        larrays = x.get_property_names(r,"SET_OF_STRING")
        lhashes = x.get_property_names(r,"MAP_STRING_STRING")
        lcia = x.get_property_names(r, "LIST_OF_CI").concat x.get_property_names(r, "SET_OF_CI")
        rt = ResourceType.new(r,parents=lparents,string_props=lstrings,array_props=larrays.concat(lcia),hash_props=lhashes)
        rt.write_file()
        pt = ResourceProvider.new(deployit_resource=r,parents=lparents,string_props=lstrings,array_props=larrays,hash_props=lhashes,ci_array_props=lcia)
        pt.write_file
      end
    end

    def do2
      x = Genres::DeployitMetaXml.new(file=@file,selector=@selector)
      x.get_types_list.each do |r|

        lparents = x.get_parents(r)
        lstrings = x.get_properties(r,"STRING")
        
        lstrings = lstrings.merge(x.get_properties(r,"ENUM"))
        larrays = x.get_property_names(r,"SET_OF_STRING")
        lhashes = x.get_property_names(r,"MAP_STRING_STRING")
        lcia = x.get_property_names(r, "LIST_OF_CI").concat x.get_property_names(r, "SET_OF_CI")
        rt = ResourceType.new(r,parents=lparents,string_props=lstrings,array_props=larrays.concat(lcia),hash_props=lhashes)
        rt.write_file()
        pt = ResourceProvider.new(deployit_resource=r,parents=lparents,string_props=lstrings,array_props=larrays,hash_props=lhashes,ci_array_props=lcia)
        pt.write_file
      end

    end
  end
end
