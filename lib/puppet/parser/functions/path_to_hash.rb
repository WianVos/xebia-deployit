require 'pathname'

module Puppet::Parser::Functions
  newfunction(:path_to_hash, :type => :rvalue, :doc => <<-EOS
    returns a hash with the all the child entry of a pathname
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "path_to_hash(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [String].include?(klass)
      raise(Puppet::ParseError, 'path_to_hash(): Requires:' +
        'string to work with')
    end
    
    result = []
    
    Pathname.new(value).descend {|v| result << v.to_s }
    
 

    return result
  end
end