Puppet::Type.newtype(:deployit_jetty_db2datasource ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_jetty_db2datasource ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_jetty_db2datasource resource state'

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
        desc 'deployit_jetty_db2datasource id (full path required)'

        validate do |value|
              fail("invalid id") unless value =~ /^(Infrastructure|Environments)/
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
    
      newproperty(:maxactive) do
         
          desc 'Max Active'
        
         
          defaultto ('8') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('maxactive needs to be set')
            end
          end
        
      end
    
      newproperty(:defaulttransactionisolation) do
         
          desc 'Default Transaction Isolation'
        
         
          defaultto ('2') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('defaulttransactionisolation needs to be set')
            end
          end
        
      end
    
      newproperty(:minidle) do
         
          desc 'Min Idle'
        
         
          defaultto ('0') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('minidle needs to be set')
            end
          end
        
      end
    
      newproperty(:servername) do
         
          desc 'Servername'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('servername needs to be set')
            end
          end
        
      end
    
      newproperty(:initialsize) do
         
          desc 'Initial Size'
        
         
          defaultto ('0') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('initialsize needs to be set')
            end
          end
        
      end
    
      newproperty(:portnumber) do
         
          desc 'Portnumber'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('portnumber needs to be set')
            end
          end
        
      end
    
      newproperty(:password) do
         
          desc 'Password'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('password needs to be set')
            end
          end
        
      end
    
      newproperty(:maxwait) do
         
          desc 'Max Wait'
        
         
          defaultto ('-1') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('maxwait needs to be set')
            end
          end
        
      end
    
      newproperty(:maxidle) do
         
          desc 'Max Idle'
        
         
          defaultto ('8') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('maxidle needs to be set')
            end
          end
        
      end
    
      newproperty(:user) do
         
          desc 'User'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('user needs to be set')
            end
          end
        
      end
    
      newproperty(:databasename) do
         
          desc 'Databasename'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('databasename needs to be set')
            end
          end
        
      end
    
      newproperty(:jndiname) do
         
          desc 'Jndi Name'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('jndiname needs to be set')
            end
          end
        
      end
    
      
      # autorequire all the deployit_core_directory resources
      [ "deployit_jetty_server", ].each {|c|
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
    