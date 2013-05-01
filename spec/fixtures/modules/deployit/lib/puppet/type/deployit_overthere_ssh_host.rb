Puppet::Type.newtype(:deployit_overthere_ssh_host) do

  desc 'adds a overthere_ssh_host to a remote deployit server'

  ensurable do

    desc 'deployit overthere_ssh_host resource state'

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

  newproperty(:connectionType) do
    defaultto('SUDO')
  end
  newproperty(:os) do
    defaultto('UNIX')
  end
  newproperty(:username) do
    defaultto('dummy')
  end
  newproperty(:password) do
    defaultto('{b64}ieRQpq8U6N4EymG4biwNOA==')
  end
  newproperty(:port) do
    defaultto('22')
  end
  newproperty(:address) do
    defaultto('localhost')
  end
  newproperty(:tags, :array_matching => :all) do    
  end
end