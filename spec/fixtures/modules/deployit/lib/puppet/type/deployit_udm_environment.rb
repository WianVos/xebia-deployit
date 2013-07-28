Puppet::Type.newtype(:deployit_udm_environment) do

  desc 'adds a udm.Dictionary ci to a remote deployit server'

  ensurable do

    desc 'deployit udm.Dictionary resource state'

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

    validate do |value|
      fail("invalid id") unless value =~ /^(Environments)/
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
  
  # property's
  newproperty(:members, :array_matching => :all ) do
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
        true
      end
  
    def should_to_s(newvalue)
          # Newvalue is an array, but we're only interested in first record.
          newvalue.inspect
        end
    
        def is_to_s(currentvalue)
          currentvalue.inspect
        end
    end

  newproperty(:dictionaries, :array_matching => :all ) do
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
          true
        end
    
      def should_to_s(newvalue)
            # Newvalue is an array, but we're only interested in first record.
            newvalue.inspect
          end
      
          def is_to_s(currentvalue)
            currentvalue.inspect
          end
      end
    
  
  
  # autorequire all the deployit_core_directory resources 
  ["deployit_core_directory","deployit_udm_dictionary","deployit_jetty_server"].each {|c|
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
  
#  
#      autorequire(c.to_sym) do
#        requires = []
#        catalog.resources.each {|d|
#          if (d.class.to_s =~ /deployit/ )
#            requires << d.name
#          end
#        }
#  
#        requires
#      end
    
end