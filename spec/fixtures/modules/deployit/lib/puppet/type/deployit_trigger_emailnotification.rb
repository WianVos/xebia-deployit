Puppet::Type.newtype(:deployit_trigger_emailnotification ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_trigger_emailnotification ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_trigger_emailnotification resource state'

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
        desc 'deployit_trigger_emailnotification id (full path required)'

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
    
      newproperty(:body) do
         
          desc 'Body'
        
        
           
        
      end
    
      newproperty(:fromaddress) do
         
          desc 'From Address'
        
        
           
        
      end
    
      newproperty(:subject) do
         
          desc 'Subject'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('subject needs to be set')
            end
          end
        
      end
    
      newproperty(:bodytemplatepath) do
         
          desc 'Body Template Path'
        
        
           
        
      end
    
      
      
    end
    