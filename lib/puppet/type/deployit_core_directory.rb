Puppet::Type.newtype(:deployit_core_directory) do

  desc 'adds a core.Directory ci to a remote deployit server'

  ensurable do

    desc 'deployit core.Directory resource state'

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

  
end