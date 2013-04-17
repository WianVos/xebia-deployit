# Class: deployit
#
# This module manages the installation of deployit
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class deployit(
  $deployit_user    = "deployit",
  $deployit_group   = "deployit",
  $deployit_homedir = "/opt/deployit",
  $deployit_version = "3.8.5",
  $deployit_admin = "admin",
  $deployit_password = "xebia123",
  $deployit_password_hash = '{b64}aU+tg3VDM813zCQVXfYsOg\=\=',
  $deployit_http_port = "4516",
  $deployit_jcr_repository_path = 'repository',
  $deployit_ssl = false,
  $deployit_http_bind_address = '0.0.0.0',
  $deployit_http_context_root = '/',
  $deployit_threads_max = '32',
  $deployit_threads_min = '4',
  $deployit_importable_packages_path = "importablePackages",
  $tmpdir = "/var/tmp",
  $install_source = "puppetfiles"
  
) {

  # input validation
  
  case $install_source {
    'nexus', 'puppetfiles' : {}
    default : {fail("${install_source} not a valid installation source")}
  }
  
  # variables
  
  $install_server_zipfile = "deployit-${deployit_version}-server.zip"
  $install_cli_zipfile = "deployit-${deployit_version}-cli.zip"
  $deployit_basedir = "${deployit_homedir}_${deployit_version}"
  
  ##flow control
  
  #normal flow
  class{deployit::users: } -> 
  class{deployit::prereq: } ->
  class{deployit::download: } ->
  class{deployit::install: } ->
  class{deployit::config: } ~>
  class{deployit::service: }
  
}
