class deployit::test::agent (
  $deployit_admin               = $deployit::deployit_admin,
  $deployit_password            = $deployit::deployit_password,
  $deployit_http_port           = $deployit::deployit_http_port,
  $deployit_http_server_address = $deployit::deployit_http_server_address,
  $ensure                       = "present") {
    
  
  # resource defaults
  
  Deployit_core_directory {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure } 

  Deployit_overthere_sshhost {
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
  Deployit_jetty_db2datasource {
    deployit_host => $deployit_http_server_address,
    ensure => $ensure
  }
 
  # actual resources
  # no flow controll needed they will autorequire there needed parents
  group {"deployit":}
  user {"deployit":
    managehome => true,
    home => "/home/deployit"
  }
  
  
  
  deployit_check_connection{"deployit central":
    host => "$deployit_http_server_address",
    port => 4516
  } ->
  
  deployit_core_directory { "Infrastructure/test": }

  deployit_core_directory { "Environments/test": }

  deployit_overthere_sshhost { "Infrastructure/test/${::operatingsystem}_${::hostname}":
    address => $::ipaddress_eth1,
    username => "deployit",
    password => "test123",
    os => "UNIX",
    connectiontype => "SUDO",
    sudousername => root
  }

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
  deployit_jetty_db2datasource{"Infrastructure/test/${::operatingsystem}_${::hostname}/server1/test1":
    servername => "test.localhost",
    user => 'admin',
    jndiname => 'jdbc://tst1/',
    portnumber => '4444',
    databasename => 'test1',
    password => '{b64}5LUBx/qD45pCHyLc13o8Sw=='
  }
  deployit_jetty_db2datasource{"Infrastructure/test/${::operatingsystem}_${::hostname}/server1/db1":
    servername => "test.localhost",
    user => 'admin',
    jndiname => 'jdbc://tst1/',
    portnumber => '4444',
    databasename => 'test1',
    password => '{b64}5LUBx/qD45pCHyLc13o8Sw=='
  }
  deployit_jetty_mqqueue{"Infrastructure/test/${::operatingsystem}_${::hostname}/server1/mq1":
    deployit_host => $deployit_http_server_address,
    jndiname => "mq://mq1",
    basequeuename => "tstmq1"
  }
  
}