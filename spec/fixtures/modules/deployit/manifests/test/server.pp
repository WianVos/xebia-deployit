class deployit::test::server (
  $deployit_admin               = $deployit::deployit_admin,
  $deployit_password            = $deployit::deployit_password,
  $deployit_http_port           = $deployit::deployit_http_port,
  $deployit_http_server_address = $deployit::deployit_http_server_address,) {
  # resource defaults
  Deployit_core_directory {
    deployit_host => $deployit_http_server_address }

  Deployit_overthere_sshhost {
    deployit_host => $deployit_http_server_address, 
    username => "admin"
  }
  Deployit_jetty_server {
    deployit_host => $deployit_http_server_address }

  Deployit_udm_dictionary {
    deployit_host => $deployit_http_server_address }

  # flow control
  Deployit_check_connection["deployit server connection"] 
  -> Deployit_core_directory["Infrastructure/Test1"] 
  -> Deployit_overthere_sshhost["Infrastructure/Test1/TestJetty1"] 
  -> Deployit_jetty_server["Infrastructure/Test1/TestJetty1/server1"]

  # actual resources
  deployit_check_connection { "deployit server connection":
    host => $deployit_http_server_address,
    port => $deployit_http_port
  }

  deployit_core_directory { "Infrastructure/Test1": }

  deployit_overthere_sshhost { "Infrastructure/Test1/TestJetty1":
    tags => ["test", "test2", "test3"],
    address => "$::hostname",
    os => "UNIX",
    username => "root"
  }

  deployit_jetty_server { "Infrastructure/Test1/TestJetty1/server1":
    tags    => ["test", "test2"],
    home    => '/opt/jetty2',
    envvars => {
      'test'  => 'test',
      'test2' => 'test2'
    }
  }

}