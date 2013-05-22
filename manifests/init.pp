# ## Class: deployit
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
# # Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class deployit (
  $deployit_user        = 'deployit',
  $deployit_group       = 'deployit',
  $deployit_homedir     = '/opt/deployit',
  $deployit_version     = '3.9.0',
  $deployit_admin       = 'admin',
  $deployit_password    = 'admin',
  $deployit_http_port   = '4516',
  $deployit_jcr_repository_path      = 'repository',
  $deployit_ssl         = false,
  $deployit_http_bind_address        = '0.0.0.0',
  $deployit_http_server_address      = '192.168.111.20',
  $deployit_http_context_root        = '/',
  $deployit_threads_max = '32',
  $deployit_threads_min = '4',
  $deployit_importable_packages_path = 'importablePackages',
  $deployit_deployment_user          = 'deployit',
  $deployit_deployment_group         = 'deployit',
  $deployit_deployment_password      = 'deployit',
  $tmpdir               = '/var/tmp',
  $install_source       = 'puppetfiles',
  $load_ci              = true,
  $server               = false,
  $ensure               = present,
  $deployit_client_profile           = 'sshhost') {
  
  # variables
  # the version dependant stuff is set here
  $server_zipfile = "deployit-${deployit_version}-server.zip"
  $cli_zipfile = "deployit-${deployit_version}-cli.zip"
  $deployit_basedir = "${deployit_homedir}_${deployit_version}"

  # #flow control

  # normal flow
  class { deployit::provider_prereq:
  } -> Class['deployit']

  # parameter dependant flow 
  
  # handle the install_source parameter
  case $install_source {
    'puppetfiles' : { }
    default       : { fail("${install_source} not a valid installation source") }
  }

  # client flows
  if $server == false {
    case $deployit_client_profile {
      'sshhost' : { Class['Deployit::Provider_prereq'] 
                    -> class { deployit::clients::sshhost: } 
                    -> Class['deployit']
      }
      default   : { fail("${deployit_client_profile} is not a valid deployit client profile") }
    }
  }

  # if server == true we do a lot of stuff .
  if $server == true {
    Class['Deployit::Provider_prereq']
    -> class { deployit::users: }
    -> class { deployit::prereq: }
    -> class { deployit::download: }
    -> class { deployit::install: }
    -> class { deployit::config: }
    ~> class { deployit::service: }
    -> Class['deployit']
  }
  
}
