Puppet::Type.newtype(:deployit_jetty_server) do

  desc 'adds a jetty.server ci to a remote deployit server'

  ensurable do

    desc 'deployit jetty.server resource state'

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
    desc 'deployit ci id (full path required)'

    validate do |value|
      fail("invalid id") unless value =~ /^(Infrastructure)/
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
  # property's

  newproperty(:home) do
    defaultto('/opt/jetty')
  end

  newproperty(:tags, :array_matching => :all ) do
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

  # this is a somewhat nifty construction
  # for this to work properly array_matching should be set to all
  newproperty(:envvars , :array_matching => :all) do

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

  # loop over the array of types we want to autorequire ... all of them :-)
  ["deployit_core_directory","deployit_overthere_ssh_host"].each {|c|
    autorequire(c.to_sym) do
      requires = []
      catalog.resources.each {|d|

        if (d.class.to_s == "Puppet::Type::#{c.capitalize}")
          requires << d.name
        end
      }
      requires
    end
  }

end