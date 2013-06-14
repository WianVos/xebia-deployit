# Class deployit::clienst::deployment_environment
#
# this class creates the basic ssh host definitions in the deployit server
class deployit::clients::deployment_environment (
  $deployit_admin,
  $deployit_password,
  $deployit_http_port,
  $deployit_http_server_address,
  $ensure             = 'present',
  $deployit_directory = undef,
  $members            = [],
  $dictionaries       = []) {
  # validity check
  if !defined(Class['Deployit::provider_prereq']) {
    class { 'deployit::provider_prereq': }
  }

  # variables
  $deployit_directory_path = $deployit_directory ? {
    undef   => 'Environments',
    default => "Environments/${deployit_directory}"
  }

  $deployit_env_path       = "${deployit_directory_path}/${name}"

  # flowcontroll
  Class[Deployit::Provider_prereq] -> File['/etc/sudoers.d/deployit'] ->
  Deployit_check_connection['deployit central'] -> Deployit_core_directory[
    $deployit_directory_path] -> Deployit_udm_environment[$deployit_env_path]

  # resource defaults

  Deployit_core_directory {
    deployit_host => $deployit_http_server_address,
    ensure        => present
  }

  # actual resources


  # The inline template used here is needed to ensure that there
  # are no newline characters at the end of the string screwing us over
  if !defined(Deployit_check_connection['deployit central']) {
    deployit_check_connection { 'deployit central':
      host => $deployit_http_server_address,
      port => $deployit_http_port
    }
  }

  deployit_core_directory { $deployit_directory_path: }

  deployit_udm_environment { $deployit_env_path:
    ensure       => $ensure,
    members      => $members,
    dictionaries => $dictionaries
  }

}