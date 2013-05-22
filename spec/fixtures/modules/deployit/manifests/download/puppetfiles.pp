# class deployit::download::puppetfiles
#
# This class handles the download of deployit
# installation archives from puppetfiles fileserving.
class deployit::download::puppetfiles (
  $deployit_version = $deployit::deployit_version,
  $deployit_user    = $deployit::deployit_user,
  $deployit_group   = $deployit::deployit_group,
  $tmpdir           = $deployit::tmpdir,
  $server_zipfile   = $deployit::server_zipfile,
  $cli_zipfile      = $deployit::cli_zipfile) {
  # resource defaults
  File {
    ensure => present,
    mode   => 700,
    owner  => $deployit_user,
    group  => $deployit_group
  }

  # resources

  file {
    "${tmpdir}/${server_zipfile}":
      source => "puppet:///modules/deployit/sources/${server_zipfile}";

    "${tmpdir}/${cli_zipfile}":
      source => "puppet:///modules/deployit/sources/${cli_zipfile}"
  }

}