Puppet::Type.newtype(:deployit_wls_sharedlibrarywar ) do

      # this type is generated with genres.rb
      # generated for deployit 3.8.5

      desc 'adds a deployit_wls_sharedlibrarywar ci to a remote deployit server'

      ensurable do

        desc 'deployit deployit_wls_sharedlibrarywar resource state'

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
        desc 'deployit_wls_sharedlibrarywar id (full path required)'

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
    
      newproperty(:stagemode) do
         
          desc 'Stage Mode'
        
        
           
        
      end
    
      newproperty(:versioned) do
         
          desc 'Versioned'
        
        
           
        
      end
    
      newproperty(:retiretimeout) do
         
          desc 'Retire Timeout'
        
        
           
        
      end
    
      newproperty(:excludefilenamesregex) do
         
          desc 'Exclude File Names Regex'
        
        
           
        
      end
    
      newproperty(:block) do
         
          desc 'Block'
        
        
           
        
      end
    
      newproperty(:automaticversioning) do
         
          desc 'Automatic Versioning'
        
        
           
        
      end
    
      newproperty(:redeploymentstrategy) do
         
          desc 'Redeployment Strategy'
        
        
           
        
      end
    
      newproperty(:deploymentorder) do
         
          desc 'Deployment Order'
        
        
           
        
      end
    
      newproperty(:versionidentifier) do
         
          desc 'Version Identifier'
        
        
           
        
      end
    
      newproperty(:stagingdirectory) do
         
          desc 'Staging Directory'
        
        
           
        
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
  
      newproperty(:placeholders , :array_matching => :all) do
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
    