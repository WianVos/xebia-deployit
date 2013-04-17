class deployit::download::puppetfiles (
  $deployit_version       = $deployit::deployit_version,
  $deployit_user          = $deployit::deployit_user,
  $deployit_group         = $deployit::deployit_group,
  $tmpdir                 = $deployit::tmpdir,
  $install_server_zipfile = $deployit::install_server_zipfile,
  $install_cli_zipfile    = $deployit::install_cli_zipfile) {
  
  # resource defaults
  File {
    ensure => present,
    mode   => 700,
    owner  => $deployit_user,
    group  => $deployit_group
  }

  # resources

  file { "${tmpdir}/${install_server_zipfile}": source => "puppet:///modules/deployit/sources/${install_server_zipfile}" }

  file { "${tmpdir}/${install_cli_zipfile}": source => "puppet:///modules/deployit/sources/${install_cli_zipfile}" }

}