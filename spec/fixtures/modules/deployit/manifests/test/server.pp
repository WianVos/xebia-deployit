class deployit::test::server(
  $deployit_admin             = "admin",
  $deployit_password          = "admin",
  $deployit_http_port         = "4516",
  $deployit_http_bind_address = '192.168.111.20',) {
  

  deployit_core_directory{"Infrastructure/Test1":
  	 } 
  
  deployit_overthere_ssh_host{"Infrastructure/Test1/TestJetty3":
    os => "UNIX",
    tags => ["test", "test2","test3"]
  }  
  deployit_overthere_ssh_host{"Infrastructure/Test1/TestJetty4":
    os => "UNIX",
    tags => ["test", "test2","test3"]
  } 
  deployit_overthere_ssh_host{"Infrastructure/Test1/TestJetty5":
    os => "UNIX",
    tags => ["test", "test2","test3"]
  } 
  deployit_overthere_ssh_host{"Infrastructure/Test1/TestJetty6":
    os => "UNIX"
  } 
  deployit_overthere_ssh_host{"Infrastructure/Test1/TestJetty11":
    os => "UNIX"
  } 
  deployit_jetty_server{"Infrastructure/Test1/TestJetty11/server4":
    tags => ["test", "test2"],
    home => '/opt/jetty2',
    envvars => {'test' => 'test',
                'test2' => 'test2'
    }
  } 
  deployit_jetty_server{"Infrastructure/Test1/TestJetty11/server1":
    tags => ["test", "test2","test3"],
    home => '/opt/jetty1',
    envvars => {'test' => 'test',
                'test2' => 'test2'
    }
  } 
  deployit_jetty_server{"Infrastructure/Test1/TestJetty11/serverx":
    tags => ["wian","test", "test2","test3"],
    home => '/opt/jetty1',
    envvars => {'test' => 'test',
                'test2' => 'test2',
                'rabo' => 'bank'
    }
  }
  
  deployit_core_directory{"Infrastructure/Benito":} ->
  deployit_overthere_ssh_host{"Infrastructure/Benito/${hostname}":
    os => "UNIX"
  } 
  deployit_jetty_server{"Infrastructure/Benito/${hostname}/server1":
    home => '/opt/jetty/server1',
    tags => ["martijn","pepping"],
    envvars => {'test' => 'test',
                'test2' => 'test2'}
  }
  deployit_core_directory{"Environments/Benito":} 
  
}