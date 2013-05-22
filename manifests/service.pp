# Class deployit::service
#
# This class manages the deployit service.
#
class deployit::service(){

  # start the deployit service
  service{'deployit':
    ensure => running,
    enable => true,
  }

}