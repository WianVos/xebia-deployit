Puppet::Type.newtype(:deployit_was_db2type2datasourcespec ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_was_db2type2datasourcespec ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_was_db2type2datasourcespec resource state'

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
        desc 'deployit_was_db2type2datasourcespec id (full path required)'

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
    
      newproperty(:username) do
         
          desc 'Username'
        
        
           
        
      end
    
      newproperty(:datasourcehelperclassname) do
         
          desc 'Datasource Helper Classname'
        
        
           
        
      end
    
      newproperty(:description) do
         
          desc 'Description'
        
        
           
        
      end
    
      newproperty(:connectionpool_connectiontimeout) do
         
          desc 'Connection pool: timeout'
        
        
           
        
      end
    
      newproperty(:password) do
         
          desc 'Password'
        
        
           
        
      end
    
      newproperty(:connectionpool_maxconnections) do
         
          desc 'Connection pool: maximum connections'
        
        
           
        
      end
    
      newproperty(:connectionpool_minconnections) do
         
          desc 'Connection pool: minimum connections'
        
        
           
        
      end
    
      newproperty(:jdbcprovider) do
         
          desc 'Jdbc Provider'
        
        
           
        
      end
    
      newproperty(:databasename) do
         
          desc 'Database Name'
        
        
           
        
      end
    
      newproperty(:jndiname) do
         
          desc 'Jndi Name'
        
        
           
        
      end
    
      newproperty(:tags , :array_matching => :all) do
        def insync?(is)

          # Comparison of Array's
          # if either the should or the is (which we get from the providers envvars method is not a hash we'll fail
          return false unless is.class == Array and should.class == Array

          # now lets compare the two and see is a modify is needed
          # haven't quite worked out yet what to do with extra values in the is hash
          @should.each do |k|

            # if is[k] is not equal to should[k] the insync? should return false
            return false unless is.include?(k)

          end
          return false unless is.length == @should.length
          true
        end

      end
  
      
      
    end
    