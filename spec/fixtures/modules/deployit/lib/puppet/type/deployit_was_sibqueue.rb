Puppet::Type.newtype(:deployit_was_sibqueue ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_was_sibqueue ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_was_sibqueue resource state'

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
        desc 'deployit_was_sibqueue id (full path required)'

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
    
      newproperty(:busname) do
         
          desc 'Bus Name'
        
        
           
        
      end
    
      newproperty(:description) do
         
          desc 'Description'
        
        
           
        
      end
    
      newproperty(:deliverymode) do
         
          desc 'Delivery Mode'
        
         
          defaultto ('Application') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('deliverymode needs to be set')
            end
          end
        
      end
    
      newproperty(:timetolive) do
         
          desc 'Time To Live'
        
        
           
        
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
      [ "deployit_was_wascontainer", ].each {|c|
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
    