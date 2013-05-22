#Class deployit::config
#
# This class handles the configuration of the deployit server
class deployit::config (
  $deployit_homedir     = $deployit::deployit_homedir,
  $deployit_user        = $deployit::deployit_user,
  $deployit_group       = $deployit::deployit_group,
  $deployit_admin       = $deployit::deployit_admin,
  $deployit_password    = $deployit::deployit_password,
  $deployit_http_port   = $deployit::deployit_http_port,
  $deployit_jcr_repository_path = $deployit::deployit_jcr_repository_path,
  $deployit_ssl         = $deployit::deployit_ssl,
  $deployit_http_bind_address = $deployit::deployit_http_bind_address,
  $deployit_http_context_root = $deployit::deployit_http_context_root,
  $deployit_threads_max = $deployit::deployit_threads_max,
  $deployit_threads_min = $deployit::deployit_threads_min,
  $deployit_importable_packages_path = $deployit::deployit_importable_packages_path) {
  # variable setting
  $deployit_password_b64 = encode_b64("${deployit_password}")

  # flow control
  File["${deployit_homedir}/server/conf/deployit.conf", 'install plugins']
  -> Ini_setting['deployit http port',
  'deployit jcr repository path',
  'deployit threads min',
  'deployit ssl',
  'deployit http bind address',
  'deployit http context root',
  'deployit threads max',
  'deployit importable packages path'
    ] -> Exec['init deployit']

  # resource default settings
  File {
    owner  => $deployit_user,
    group  => $deployit_group,
    ensure => present,
    mode   => 750
  }

  Ini_setting {
    path    => "${deployit_homedir}/server/conf/deployit.conf",
    ensure  => present,
    section => ''
  }

  # resources

  # this touches the file so that the later ini_settings resources have something to chew on
  file { "${deployit_homedir}/server/conf/deployit.conf": }

  file { "install plugins":
    source       => ["puppet:///modules/deployit/plugins/","${deployit_homedir}/server/available-plugins"],
    sourceselect => all,
    recurse      => remote,
    path         => "${deployit_homedir}/server/plugins"
  }

  
  # ini setting sets a specific variable in a stanza file .
  # this type and providers is stolen
  # but is incorporated in this package
  # we only need to use this because deployit can't keep it's nasty paws out of it's own config file

  ini_setting { 'deployit http port':
    setting => 'http.port',
    value   => "${deployit_http_port}"
  }

  ini_setting { 'deployit jcr repository path':
    setting => 'jcr.repository.path',
    value   => "${deployit_jcr_repository_path}"
  }

  ini_setting { 'deployit threads min':
    setting => "threads.min",
    value   => "${deployit_threads_min}"
  }

  ini_setting { 'deployit ssl':
    setting => 'ssl',
    value   => "${deployit_ssl}"
  }

  ini_setting { 'deployit http bind address':
    setting => 'http.bind.address',
    value   => "${deployit_http_bind_address}"
  }

  ini_setting { 'deployit http context root':
    setting => 'http.context.root',
    value   => "${deployit_http_context_root}"
  }

  ini_setting { 'deployit threads max':
    setting => "threads.max",
    value   => $deployit_threads_max
  }

  ini_setting { 'deployit importable packages path':
    setting => 'importable.packages.path',
    value   => $deployit_importable_packages_path
  }

  # 'deployit password':
  #      setting => 'admin.password',
  #      value   => $deployit_password;

  # this exec .. o how i hate exec's .. is needed for deployit to initialize it's jcr repository
  # further more i'd like to state that the way it's configuration files are handled by deployit is absolute crap
  exec { "init deployit":
    creates   => "${deployit_homedir}/server/repository",
    command   => "${deployit_homedir}/server/bin/server.sh -setup -reinitialize -force -setup-defaults ${deployit_homedir}/server/conf/deployit.conf",
    logoutput => true,
    user      => $deployit_user
  }
}

