class deployit::provider_prereq () {
  # the provider needs a couple of ruby gems in order to function correctly. 
  # We will need these to make all the other stuff work .
  # In case of puppet enterprise it gets a little harder though because then the gems 
  #will need to be installed under the specific ruby version that comes with puppet enterprise 
  # # input validation

  # # variable setting
  # dependant on the os (windows might be an option in the future) we select the gems
  case $osfamily {
    'RedHat', 'Debian' : { $xtra_gems = ["xml-simple", "rest-client", "mime-types"] }
    default            : {}
  }

  

  # if the fact pe_version is nil aka unset the we all is well 
  # otherwise we need to link the gem command in /opt/puppet/bin to /usr/sbin
  if $::pe_version != nil {
    File["pe gem link"] -> Package[$xtra_gems] 

    file { "pe gem link":
      ensure => link,
      path   => "/usr/sbin/gem",
      target => "/opt/puppet/bin/gem"
    }
  } else {
    
    # we need flow .. flow is good . it ensures things
    Package["rubygems"] -> Package[$xtra_gems] 
    
    # if not pe_version then install the rubygems package
    package { 'rubygems': }
    
  }

  # packages
  package { $xtra_gems: provider => gem }

}