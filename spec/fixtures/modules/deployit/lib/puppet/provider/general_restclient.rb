require File.expand_path('../../deployit_util/ci.rb', __FILE__)

class Puppet::Provider::General_restclient < Puppet::Provider

  confine :feature => :restclient
  def initialize(value={})
    super(value)
    @deployit_type = self.class.deployit_type
    @properties = self.class.properties
    @array_properties = self.class.array_properties
    @hash_properties = self.class.hash_properties
    @parent = self.class.parent

    unless @properties == nil

      @properties.each do | prop |
        downcase_prop = prop.downcase
        #use instance eval to dynamicly add code to the class ..
        instance_eval %Q{

        # add a method with the name #{prop}
        def #{downcase_prop}
        # get the property from the property hash
         result = nil
         if @property_hash.has_key?("#{prop}")
           result = @property_hash["#{prop}"]
         end
        # check if the result is not nil

         unless result == nil
        #results are returned as arrays this doesn't work for puppet so let's cut them down to size if needed
         result = result.first unless result.length > 1

        return result
       end

     # and return the fruit of our labor
     return result
    end

    # add setter method
    def #{downcase_prop}=(value)
     # add the value to the hash in the correct place
     @property_hash["#{prop}"] = value
    end
    }

      end
    end
    
    # and again for the array properties if there there
    unless @array_properties == nil
      @array_properties.each do |aprop|
        downcase_aprop = aprop.downcase

        instance_eval %Q{def #{downcase_aprop}
        result = nil
        if @property_hash.has_key?("#{aprop}")
          result = @property_hash["#{aprop}"].first['value']

          result.shift if result != nil and result.first.is_a?(Hash)

        end
        # check if the result is not nil

        return result
      end

      def #{downcase_aprop}=(value)
        @property_hash["#{aprop}"] = {'values' => value }

      end
    }
      end
    end
    # .... hash properties.
    unless @hash_properties == nil

      @hash_properties.each do |hprop|
        downcase_hprop = hprop.downcase

        instance_eval %Q{
      def #{downcase_hprop}
       result = {}

       if  @property_hash.has_key?("#{hprop}")

           @property_hash["#{hprop}"].first['entry'].each {|d| result["\#{d['key']}"] = d['content']} if @property_hash["#{hprop}"].first.has_key?('entry')

              end
              return result

       end
       def #{downcase_hprop}=(value)
             @property_hash['#{hprop}'] = [{ 'entry' => []}]
             value.first.each {|key, value| @property_hash['#{hprop}'].first['entry'] << { "content" => value,  "@key" => key } }

       end

    }

      end
    end
  end

  
  def exists?

    get_props_hash

    @property_hash["exists"] == true

  end

  # the create method gets called when a type has ensure set to present but the resource is not available on the remote system
  
  def create
  
    # we have three catagories of properties that need to be added to the properties hash
    # loop over the regular properties and add the values to the property hash ready for flushing  
    if @properties != nil
      @properties.each do |p|

        @property_hash["#{p}"] = resource["#{p}".downcase.to_sym] unless resource["#{p}".downcase.to_sym] == nil

      end
    end
    
    # do the same for hash properties 
    # instead of just adding them to the hash we have to send them to the meta created method using the ruby send method
    # btw we need to downcase the properties name
    if @hash_properties != nil
      @hash_properties.each do |hp|
        dhp = hp.downcase
       send("#{dhp}=",resource["#{dhp}".to_sym])
      end
    end
    
    # and again for array properties
    if @array_properties != nil
      @array_properties.each do |ap|
        dap = ap.downcase
        send("#{dap}=",resource["#{dap}".to_sym])
      end
    end
    
    # set the ensure property to present
    # we are creating ... you know.
    @property_hash["ensure"] = "present"
      
  end

  def destroy
    # hoeray for flushing .. the only thing we need to do here is set ensure to absent
    @property_hash["ensure"] = "absent"
  end

  def get_props_hash

    # initialize the global property_hash
    @property_hash = {}

    # initialize the ensure property with the present value
    # if the destroy method gets called it will change to absent

    # setup a new connection to the deployit server
    c = Puppet::Deployit_util::Ci.new(resource[:deployit_username], resource[:deployit_password], resource[:deployit_protocol], resource[:deployit_host], resource[:deployit_port])

    #check if the resource exists
    if c.ci_exists?(resource[:id]) == true

      # if it does exist
      # get the ci's property's into a hash
      @property_hash = c.get_ci_hash(resource[:id])
      @property_hash["ensure"] = "present"
      @property_hash["exists"] = true

    else

      # if it doesn't exist set the exists field to false
      @property_hash["exists"] = false
      @property_hash["ensure"] = "present"

    end

  end

  # the flush method will actualize the settings to deployit
  def flush
    # remove the confilicting fields from the hash and get the values to seperate variables we can use the determine the flow of the flush
    ensure_prop = @property_hash.delete('ensure')
    exists = @property_hash.delete('exists')
    # get a connection to deployit
    c = Puppet::Deployit_util::Ci.new(resource[:deployit_username], resource[:deployit_password], resource[:deployit_protocol], resource[:deployit_host], resource[:deployit_port])

    #check if the ensure param is set to present
    if ensure_prop == "present"

      # push the property hash to the deployit server
      # if the resource exists just modify it .. else create it
      if exists == true
        c.modify_ci(resource[:id], @deployit_type , @property_hash )

      else
        result = c.add_ci(resource[:id], @deployit_type , @property_hash, @parent )
        self.fail result unless result == "succes"
      end

    else

      # delete the resource if ensure is set to absent

      c.delete_ci(resource[:id]) if exists == true

    end

  end

end