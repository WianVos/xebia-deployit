class deployit::test::agent (
  $deployit_admin               = "admin",
  $deployit_password            = "admin",
  $deployit_http_port           = "4516",
  $deployit_http_server_address = '192.168.111.20',
  $ensure                       = "present") {
    
  # resource defaults
  Deployit_core_directory {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure } 

  Deployit_overthere_ssh_host {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure } 

  Deployit_jetty_server {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure }

  Deployit_udm_dictionary {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure } 
  Deployit_udm_environment {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure }
 
  # actual resources
  # no flow controll needed they will autorequire there needed parents
  
  deployit_core_directory { "Infrastructure/test": }

  deployit_core_directory { "Environments/test": }

  deployit_overthere_ssh_host { "Infrastructure/test/${::operatingsystem}_${::hostname}": }

  deployit_jetty_server { "Infrastructure/test/${::operatingsystem}_${::hostname}/server1":
    tags    => [$::operatingsystem, $::virtual],
    home    => '/opt/jetty2',
    envvars => {
      'selinux'     => "${::selinux}",
      'memorytotal' => "${::memorytotal}"
    }
  }

  deployit_udm_dictionary { "Environments/test/${::hostname}":
    entries => {
      'hostname'    => "${::hostname}",
      'environment' => 'test'
    }
  }
  deployit_udm_dictionary { "Environments/test/${::hostname}1":
    entries => {
      'hostname'    => "${::hostname}",
      'environment' => 'test'
    }
  }
  deployit_udm_environment{"Environments/test/test1":
    members => ["Infrastructure/test/${::operatingsystem}_${::hostname}","Infrastructure/test/${::operatingsystem}_${::hostname}/server1" ],
    dictionaries => ["Environments/test/${::hostname}","Environments/test/${::hostname}1"]
  }

}