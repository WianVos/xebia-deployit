Puppet::Type.newtype(:deployit_wls_domain ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_wls_domain ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_wls_domain resource state'

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
        desc 'deployit_wls_domain id (full path required)'

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
    
      newproperty(:domainhome) do
         
          desc 'WebLogic domain home'
        
        
           
        
      end
    
      newproperty(:password) do
         
          desc 'Administrative password'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('password needs to be set')
            end
          end
        
      end
    
      newproperty(:protocol) do
         
          desc 'Administrative server protocol'
        
         
          defaultto ('t3') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('protocol needs to be set')
            end
          end
        
      end
    
      newproperty(:version) do
         
          desc 'Version'
        
         
          defaultto ('WEBLOGIC_10') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('version needs to be set')
            end
          end
        
      end
    
      newproperty(:adminservername) do
         
          desc 'Admin Server Name'
        
         
          defaultto ('AdminServer') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('adminservername needs to be set')
            end
          end
        
      end
    
      newproperty(:startmode) do
         
          desc 'Start Mode'
        
         
          defaultto ('NodeManager') 
        
           
         
          validate do |value|
            unless value != 'unset'
              fail('startmode needs to be set')
            end
          end
        
      end
    
      newproperty(:wlhome) do
         
          desc 'WebLogic home'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('wlhome needs to be set')
            end
          end
        
      end
    
      newproperty(:wlstpath) do
         
          desc 'WLST path'
        
        
           
        
      end
    
      newproperty(:username) do
         
          desc 'Administrative username'
        
        
        
          defaultto('unset')
           
         
          validate do |value|
            unless value != 'unset'
              fail('username needs to be set')
            end
          end
        
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
  
      newproperty(:clusters , :array_matching => :all) do
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
  
      newproperty(:servers , :array_matching => :all) do
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
  
      
      # autorequire all the deployit_core_directory resources
      [ "deployit_core_directory",  "deployit_overthere_host",  "deployit_overthere_sshhost",  "deployit_overthere_cifshost", ].each {|c|
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
    