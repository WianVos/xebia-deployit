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
  $deployit_password = "xebia1234",
  $deployit_http_port = "4516",
  $deployit_jcr_repository_path = 'repository',
  $deployit_ssl = false,
  $deployit_http_bind_address = '0.0.0.0',
  $deployit_http_context_root = '/',
  $deployit_threads_max = '32',
  $deployit_threads_min = '4',
  $deployit_importable_packages_path = "importablePackages",
  $tmpdir = "/var/tmp",
  $install_source = "puppetfiles",
  $development = true
  
) {

  # input validation
  
  case $install_source {
   'puppetfiles' : {}
    default : {fail("${install_source} not a valid installation source")}
  }
  
  case $development {
    true, false : {}
    default : {fail("${development} not a valid value for parameter development")}
  }
  
  # variables
  
  $server_zipfile = "deployit-${deployit_version}-server.zip"
  $cli_zipfile = "deployit-${deployit_version}-cli.zip"
  $deployit_basedir = "${deployit_homedir}_${deployit_version}"
  
  ##flow control
  
  #normal flow
  class{deployit::users: } -> 
  class{deployit::prereq: } ->
  class{deployit::download: } ->
  class{deployit::install: } ->
  class{deployit::config: } ~>
  class{deployit::service: } ->
  Class["deployit"]
  
  if $development == true {Class["deployit::service"] -> class{deployit::development: } -> Class["deployit"]}
}
