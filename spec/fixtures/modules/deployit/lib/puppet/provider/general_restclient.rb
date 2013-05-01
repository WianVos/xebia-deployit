require File.expand_path('../../deployit_util/ci.rb', __FILE__)

class Puppet::Provider::General_restclient < Puppet::Provider

  confine :feature => :restclient
  def initialize(value={})
    super(value)
    @deployit_type = self.class.deployit_type
    @properties = self.class.properties
    @array_properties = self.class.simple_array_properties
    @parent = self.class.parent

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
        p value
        @property_hash["#{aprop}"] = {'values' => value }

      end
  }
    end
  end

  def exists?
    p "exists"

    get_props_hash

    @property_hash["exists"] == true
  end

  def create
    @properties.each do |p|

      @property_hash["#{p}"] = resource["#{p}".downcase.to_sym] unless resource["#{p}".downcase.to_sym] == nil

    end

    @property_hash["ensure"] = "present"
  end

  def destroy
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
      p @property_hash
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
