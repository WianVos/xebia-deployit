class deployit::test::agent (
  $deployit_admin             = "admin",
  $deployit_password          = "admin",
  $deployit_http_port         = "4516",
  $deployit_http_bind_address = '192.168.111.20',) {
  Deployit_core_directory {
    deployit_host => $deployit_http_bind_address }

  Deployit_overthere_ssh_host {
    deployit_host => $deployit_http_bind_address }

  Deployit_jetty_server {
    deployit_host => $deployit_http_bind_address }

  Deployit_udm_dictionary {
    deployit_host => $deployit_http_bind_address }

  deployit_core_directory { "Infrastructure/test": }

  deployit_core_directory { "Environments/test": }

  deployit_overthere_ssh_host { "Infrastructure/test/${::operatingsystem}_${::hostname}": }

  deployit_jetty_server { "Infrastructure/test/${::operatingsystem}_${::hostname}/server1":
    tags    => [$::operatingsystem, $::virtual],
    home    => '/opt/jetty2',
    envvars => {
      'selinux'     => "${::selinux}",
      'memorytotal' => "${::memorytotal}"
    }
  }

  deployit_udm_dictionary { "Environments/test/${::hostname}":
    entries => {
      'hostname'    => "${::hostname}",
      'environment' => 'test'
    }
  }

}