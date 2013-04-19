Puppet::Type.newtype(:deployit_sshhost) do

  desc 'custom type to remotely add a ssh host to deployit'

  # ensurable
  ensurable do
    desc "deployit sshhost resource state"

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:id, :namevar => true) do
  end
  
  newproperty(:os) do
  	desc 'set the ostype of a host'
    defaultto :UNIX
    newvalues(:UNIX, :WINDOWS)
  end

 newproperty(:connectiontype) do
    desc 'deployit ssh connectiontype'
    
  
  <os>UNIX</os>
  <connectionType>SUDO</connectionType>
  <address>192.168.111.111</address>
  <port>22</port>
  <username>admin</username>
  <password>{b64}KLomG9XiH0ebFpjJAXuJaQ==</password>