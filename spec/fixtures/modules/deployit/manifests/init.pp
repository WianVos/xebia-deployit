### Class: deployit
# This puppet module can do one of two things
# it installs Xebialabs deployit for you 
# on top of that has a number of resources that will enable you 
# to add configuration items to deployit from anywhere in your infrastructure by using the deployit rest interface
#
# Versioning
# this module is tested for 
# Centos 6.4 & Deployit 3.8.5
# 
# 
#
## Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class deployit (
  $deployit_user        = "deployit",
  $deployit_group       = "deployit",
  $deployit_homedir     = "/opt/deployit",
  $deployit_version     = "3.8.5",
  $deployit_admin       = "admin",
  $deployit_password    = "xebia1234",
  $deployit_http_port   = "4516",
  $deployit_jcr_repository_path      = 'repository',
  $deployit_ssl         = false,
  $deployit_http_bind_address        = '192.168.111.20',
  $deployit_http_context_root        = '/',
  $deployit_threads_max = '32',
  $deployit_threads_min = '4',
  $deployit_importable_packages_path = "importablePackages",
  $tmpdir               = "/var/tmp",
  $install_source       = "puppetfiles",
  $development          = true,
  $load_ci              = true,
  $server               = false, 
  $test                 = true) {
  # input validation

  # handle the install_source parameter
  case $install_source {
    'puppetfiles' : { }
    default       : { fail("${install_source} not a valid installation source") }
  }

  # handle the development parameter
  case $development {
    true, false : { }
    default     : { fail("${development} not a valid value for parameter development") }
  }

  # variables
  # the version dependant stuff is set here
  $server_zipfile = "deployit-${deployit_version}-server.zip"
  $cli_zipfile = "deployit-${deployit_version}-cli.zip"
  $deployit_basedir = "${deployit_homedir}_${deployit_version}"

  # #flow control

  # normal flow
  class { deployit::provider_prereq:
  } -> Class["deployit"]
  
  # if server == true we do a lot of stuff . 
  if $server == true {
    Class["Deployit::Provider_prereq"] -> class { deployit::users: } -> class { deployit::prereq: } -> class { deployit::download: } 
    -> class { deployit::install: } -> class { deployit::config: } ~> class { deployit::service: } -> Class["deployit"]
  }
  
  # if development == true we do a lott less

  if $development == true {
    Class["deployit::provider_prereq"] -> class { deployit::development: } -> Class["deployit"]
  }

  # this will be removed before the 1.0 version 
  # because we lack a decent application server module but have to test the type's and providers .. 
  if $test == true {
    case $server {
      true : {Class["deployit::service"]-> class{deployit::test::server:} -> Class["deployit"]}
      false: {Class["deployit::provider_prereq"]-> class{deployit::test::agent:} -> Class["deployit"]}
    }
  }
}
