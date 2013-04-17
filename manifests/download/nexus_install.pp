class deployit::download::nexusinstall (
  $deployit_version       = $deployit::deployit_version,
  $tmpdir                 = $deployit::tmpdir,
  $install_server_zipfile = $deployit::install_server_zipfile,
  $install_cli_zipfile    = $deployit::install_cli_zipfile) {
 
  # # resource defaults
 
  Nexus::Artifact {
    packaging  => 'zip',
    repository => 'releases',
    ensure     => present,
  }

  # # resources

  # Initialize Nexus

  class { 'nexus':
    url      => "http://dexter.xebialabs.com/nexus",
    username => "deployment",
    password => "_#$(%RJf-W}",
  }

  nexus::artifact { 'deployit-server':
    gav        => "com.xebialabs.deployit:deployit:${deployit_version}",
    classifier => 'server',
    output     => "${tmpdir}/${install_server_zipfile}",
  }

  nexus::artifact { 'deployit-cli':
    gav        => "com.xebialabs.deployit:deployit:${deployit_version}",
    classifier => 'cli',
    output     => "${tmpdir}/${install_server_zipfile}",
  }

}