class deployit::post_install (
  $deployit_admin             = "admin",
  $deployit_password          = "xebia1234",
  $deployit_http_port         = "4516",
  $deployit_http_bind_address = '0.0.0.0',) {
  deployit_ci { "Infrastructure/TestII":
    type     => "core.Directory",
    username => "admin",
    password => "admin",
  }

  deployit_ci { "Infrastructure/TestIII":
    type     => "core.Directory",
    username => "admin",
    password => "admin",
  }

  deployit_ci { "Infrastructure/TestJetty":
    type       => 'overthere.SshHost',
    username   => 'admin',
    password   => 'admin',
    properties => {
      "address"        => "0.0.0.0",
      "connectionType" => "SUDO",
      "os"             => "UNIX",
      "username"      => "test1",
      "password"      => "{b64}ieRQpq8U6N4EymG4biwNOA=="
    }
  }
  deployit_ci { "Infrastructure/TestJetty22":
    type       => 'overthere.SshHost',
    username   => 'admin',
    password   => 'admin',
    properties => {
      "address"        => "0.0.0.1",
      "connectionType" => "SUDO",
      "os"             => "UNIX",
      "username"      => "test1",
      "password"      => "{b64}ieRQpq8U6N4EymG4biwNOA==",
      "port"          => "24"
    }
  }
  deployit_ci { "Infrastructure/Test1/TestJetty22":
    type       => 'overthere.SshHost',
    username   => 'admin',
    password   => 'admin',
    properties => {
      "address"        => "0.0.0.0",
      "connectionType" => "SUDO",
      "os"             => "UNIX",
      "username"      => "test1",
      "password"      => "{b64}ieRQpq8U6N4EymG4biwNOA=="
    }
  }
  deployit_overthere_ssh_host{"Infrastructure/Test1/TestJetty3":
    os => "UNIX"
  }
}