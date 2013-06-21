#Class deployit::clienst::sshhost
#
# this class creates the basic ssh host definitions in the deployit server
define deployit::clients::deployment_environment (
  $deployit_admin,
  $deployit_password,
  $deployit_http_port,
  $deployit_http_server_address,
  $ensure = 'present',
  $deployit_directory  = undef,
  $members = undef,
  $dictionaries = undef,
  ) {

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
    undef => 'Environments',
    default => "Environments/${deployit_directory}"
    }


  $deployit_env_name = "${deployit_directory_path}/${name}"

  # flowcontroll
  Class[Deployit::Provider_prereq]
  -> File['/etc/sudoers.d/deployit']
  -> Deployit_check_connection['deployit central']
  -> Deployit_core_directory[$deployit_directory_path]
  -> Deployit_udm_environment[$deployit_env_name]

  # resource defaults

  Deployit_core_directory {
    deployit_host => $deployit_http_server_address,
    ensure        => present
  }

  Deployit_udm_environment {
    deployit_host => $deployit_http_server_address,
    ensure        => $ensure
  }

  # os dependant settings




 if !defined(Deployit_check_connection['deployit central']){ deployit_check_connection { 'deployit central':
    host => $deployit_http_server_address,
    port => $deployit_http_port
  }
}
  deployit_core_directory { $deployit_directory_path: }

  deployit_udm_environment {
    $deployit_env_name:
    ensure         => $ensure,
    members       => $members,
    dictionaries  => $dictionaries,
  }

}