Puppet::Type.newtype(:deployit_wls_jmsfilepersistentstore ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_wls_jmsfilepersistentstore ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_wls_jmsfilepersistentstore resource state'

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
        desc 'deployit_wls_jmsfilepersistentstore id (full path required)'

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
    
      newproperty(:directory) do
         
          desc 'Directory'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('directory needs to be set')
            end
          end
        
      end
    
      newproperty(:targetrestartpolicy) do
         
          desc 'Target Restart Policy'
        
         
          defaultto ('RESTART') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('targetrestartpolicy needs to be set')
            end
          end
        
      end
    
      newproperty(:synchronouswritepolicy) do
         
          desc 'Synchronous Write Policy'
        
         
          defaultto ('Cache-Flush') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('synchronouswritepolicy needs to be set')
            end
          end
        
      end
    
      
      # autorequire all the deployit_core_directory resources
      [ "deployit_wls_jmsserver",  "deployit_core_directory", ].each {|c|
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
    