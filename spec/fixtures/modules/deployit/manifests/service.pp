class deployit::service(){
  
  # start the deployit service
  service{'deployit':
    ensure => running,
    enable => true,
  }
  
}