class deployit::service(){
  
  service{'deployit':
    ensure => running,
    enable => true,
  }
  
}