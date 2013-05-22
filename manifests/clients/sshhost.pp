#Class deployit::clienst::sshhost
#
# this class creates the basic ssh host definitions in the deployit server
class deployit::clients::sshhost (
  $deployit_admin      = $deployit::deployit_admin,
  $deployit_password   = $deployit::deployit_password,
  $deployit_http_port  = $deployit::deployit_http_port,
  $deployit_http_server_address = $deployit::deployit_http_server_address,
  $ensure              = $deployit::ensure,
  $deployment_user     = $deployit::deployit_deployment_user,
  $deployment_group    = $deployit::deployit_deployment_group,
  $deployment_password = $deployit::deployit_deployment_password) {

  # validity check
  if ! defined(Class['Deployit']) {
    fail('do not include this class directly')
  }

  # flowcontroll
  Group[$deployment_group]
  -> User[$deployment_user]
  -> File['/etc/sudoers.d/deployit']
  -> Deployit_check_connection['deployit central']
  -> Deployit_core_directory["Infrastructure/${::osfamily}"]
  -> Deployit_overthere_sshhost[
    "Infrastructure/${::osfamily}/${::operatingsystem}_${::hostname}"]

  # resource defaults

  Deployit_core_directory {
    deployit_host => $deployit_http_server_address,
    ensure        => present
  }

  Deployit_overthere_sshhost {
    deployit_host => $deployit_http_server_address,
    ensure        => $ensure
  }

  # os dependant settings


  # actual resources
  group { $deployment_group: ensure => $ensure }

  user{ $deployment_user :
    ensure     => $ensure,
    managehome => true,
    home       => "/home/${deployment_user}",
    gid        => $deployment_group,
   # password   => str2saltedsha512($deployment_password)
  }

  file { '/etc/sudoers.d/deployit':
    content => "${deployment_user}  ALL=(ALL)   NOPASSWD: ALL"
  }

  deployit_check_connection { 'deployit central':
    host => $deployit_http_server_address,
    port => $deployit_http_port
  }

  deployit_core_directory { "Infrastructure/${::osfamily}": }

  deployit_overthere_sshhost {
    "Infrastructure/${::osfamily}/${::operatingsystem}_${::hostname}":
    ensure         => $ensure,
    address        => $::ipaddress_eth1,
    username       => 'deployit',
    password       => 'test123',
    os             => 'UNIX',
    connectiontype => 'SUDO',
    sudousername   => root
  }

}