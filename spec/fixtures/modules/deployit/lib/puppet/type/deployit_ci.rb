Puppet::Type.newtype(:deployit_ci) do

  desc 'adds a ci to a remote deployit host'

  ensurable do

    desc 'deployit ci resource state'

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
  end

  # general properties

  newparam(:type) do
    desc 'provider type'

  end

  newparam(:username) do
    desc 'a valid deployit user'

  end

  newparam(:password) do
    desc 'the password for the deployit user'

  end

  newparam(:host) do
    desc 'address of the deployit server'
    defaultto('localhost')
  end

  newparam(:port) do
    desc 'port to reach the deployit server on'
    defaultto('4516')
  end

  newparam(:protocol) do
    desc 'protocol to use in communication to the deployit host'
    defaultto('http')
  end
  # property's
  newproperty(:properties, :array_matching => :all) do
    desc 'a hash of valid propertys to be sent to deployit'

    validate do |value|
      raise ArgumentError, "Puppet::Type::deployit_ci: property must be a hash." unless value.is_a? Hash
    end

    def insync?(is)
      # @should is an Array. see lib/puppet/type.rb insync?
      should = @should.first
      # Comparison of hashes
      return false unless is.class == Hash and should.class == Hash
      should.each do |k,v|
       
        return false unless is[k].to_s == should[k].to_s
        
      end
      true
    end

    def should_to_s(newvalue)
      p "should_to_s"
      # Newvalue is an array, but we're only interested in first record.
      newvalue = newvalue.first
      newvalue.inspect
    end

    def is_to_s(currentvalue)
      p "is_to_s"
      currentvalue.inspect
    end
  end

end