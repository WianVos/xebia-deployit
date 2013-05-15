Puppet::Type.newtype(:deployit_was_jdbcprovider ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_was_jdbcprovider ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_was_jdbcprovider resource state'

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
        desc 'deployit_was_jdbcprovider id (full path required)'

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
    
      newproperty(:implementationclassname) do
         
          desc 'Implementation class name'
        
        
           
        
      end
    
      newproperty(:nativepath) do
         
          desc 'Native Library Path'
        
        
           
        
      end
    
      newproperty(:classpath) do
         
          desc 'Class path'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('classpath needs to be set')
            end
          end
        
      end
    
      newproperty(:description) do
         
          desc 'Description'
        
        
           
        
      end
    
      newproperty(:providertype) do
         
          desc ' Provider type'
        
        
           
        
      end
    
      
      # autorequire all the deployit_core_directory resources
      [ "deployit_was_wascontainer",  "deployit_core_directory", ].each {|c|
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
    