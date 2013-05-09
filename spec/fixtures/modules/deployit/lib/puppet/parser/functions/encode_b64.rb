require 'base64'

module Puppet::Parser::Functions
  newfunction(:encode_b64, :type => :rvalue, :doc => <<-EOS
    Encodes a string into a b64 type hash
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "encode_b64(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    unless [String].include?(klass)
      raise(Puppet::ParseError, 'encode_b64(): Requires:' +
        'string to work with')
    end

    
      result = Base64.encode64 value
 

    return result
  end
end