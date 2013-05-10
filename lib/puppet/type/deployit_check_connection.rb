Puppet::Type.newtype(:deployit_check_connection) do
  
  ensurable do
      defaultvalues
      defaultto :present
    end

  newparam(:name, :namevar => true ) do 
    desc 'just a name '
  end
  newparam(:host) do

    desc 'the resolvable hostname of the deployit server to be tested '
    
  end
  
  newparam(:port) do

    desc 'the port of the deployit server'
  end
  
  newparam(:timeout) do

    defaultto 5

    validate do |value|
      # This will raise an error if the string is not an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end

end