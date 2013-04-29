class deployit::provider_prereq () {
  # # input validation

  # # variable setting
  case $osfamily {
    'RedHat', 'Debian' : { $xtra_gems = ["xml-simple", "rest-client", "mime-types"] }
    default            : {}
  }

  # # flow control


  if $::pe_version != nil {
    File["pe gem link"] -> Package[$xtra_gems] 

    file { "pe gem link":
      ensure => link,
      path   => "/usr/sbin/gem",
      target => "/opt/puppet/bin/gem"
    }
  } else {
    Package["rubygems"] -> Package[$xtra_gems] 

    package { 'rubygems': }
  }

  # packages
  package { $xtra_gems: provider => gem }

}