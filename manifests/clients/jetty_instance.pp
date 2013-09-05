# Class deployit::clienst::sshhost
#
# this class creates the basic ssh host definitions in the deployit server
define deployit::clients::jetty_instance (
  $deployit_admin,
  $deployit_password,
  $deployit_http_port,
  $deployit_http_server_address,
  $deployment_user,
  $deployment_group,
  $deployment_password,
  $jetty_home,
  $tags               = undef,
  $envvars            = undef,
  $ensure             = 'present',
  $deployit_directory = undef,) {

  # prereqs
  if !defined(Class['Deployit::Clients::Sshhost']) {
    class { 'deployit::clients::sshhost':
      ensure              => $ensure,
      deployit_admin      => $deployit_admin,
      deployit_password   => $deployit_password,
      deployit_http_port  => $deployit_http_port,
      deployit_http_server_address => $deployit_http_server_address,
      deployment_user     => $deployment_user,
      deployment_group    => $deployment_group,
      deployment_password => $deployment_password,
      deployit_directory  => $deployit_directory
    }
  }

  # variables
  $deployit_instance_path = $deployit_directory ? {
    undef   => 'Infrastructure/${::hostname}/${name}',
    default => "Infrastructure/${deployit_directory}/${::hostname}/${name}"
  }

  # flow controll
  Class['Deployit::Clients::Sshhost'] -> Deployit_jetty_server[$deployit_instance_path]

  # resource defaults

  Deployit_jetty_server {
    deployit_username => $deployit_admin,
    deployit_password => $deployit_password,
    deployit_host => $deployit_http_server_address,
    ensure        => present
  }
  # resources
  deployit_jetty_server { $deployit_instance_path:
    tags    => $tags ? {
      undef   => undef,
      default => $tags
    },
    envvars => $envvars ? {
      undef   => undef,
      default => $envvars,
    },
    home    => $jetty_home,
  }
}