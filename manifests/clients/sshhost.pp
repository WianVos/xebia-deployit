#Class deployit::clienst::sshhost
#
# this class creates the basic ssh host definitions in the deployit server
class deployit::clients::sshhost (
  $deployit_admin,
  $deployit_password,
  $deployit_http_port,
  $deployit_http_server_address,
  $deployment_user,
  $deployment_group,
  $deployment_password,
  $ensure = 'present',
  $deployit_directory  = undef ) {

  # password hash value
  # translating a string password to somethin usable by centos is a bit of an efford
  # TODO: See if ubuntu needs this as well
  # $password_md5_hash = generate('/usr/bin/openssl', 'passwd', '-1', $deployment_password)

  # validity check
  if ! defined(Class['Deployit::provider_prereq']) {
    class{'deployit::provider_prereq':}
  }

  # variables
  $deployit_directory_path = $deployit_directory ? {
    undef => 'Infrastructure',
    default => "Infrastructure/${deployit_directory}"
    }

  $deployit_host_path = "${deployit_directory_path}/${::hostname}"

  # flowcontroll
  Class[Deployit::Provider_prereq]
  -> Group[$deployment_group]
  -> User[$deployment_user]
  -> File['/etc/sudoers.d/deployit']
  -> Deployit_check_connection['deployit central']
  -> Deployit_core_directory[$deployit_directory_path]
  -> Deployit_overthere_sshhost[
    $deployit_host_path]

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
  if ! defined(Group[$deployment_group]) {
    group { $deployment_group: ensure => $ensure }

  }

  # The inline template used here is needed to ensure that there
  # are no newline characters at the end of the string screwing us over
  user{ $deployment_user :
    ensure     => $ensure,
    managehome => true,
    home       => "/home/${deployment_user}",
    gid        => $deployment_group,
    #password   => inline_template('<%= password_md5_hash.strip() %>')
    password   => md5pass($deployment_password)
  }

  file { '/etc/sudoers.d/deployit':
    content => "${deployment_user}  ALL=(ALL)   NOPASSWD: ALL"
  }

  deployit_check_connection { 'deployit central':
    host => $deployit_http_server_address,
    port => $deployit_http_port
  }

  deployit_core_directory { $deployit_directory_path: }

  deployit_overthere_sshhost {
    $deployit_host_path:
    ensure         => $ensure,
    address        => $::ipaddress_eth1,
    username       => $deployment_user,
    password       => $deployment_password,
    os             => 'UNIX',
    connectiontype => 'SUDO',
    sudousername   => root
  }

}