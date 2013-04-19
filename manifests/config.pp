class deployit::config (
  $deployit_homedir     = $deployit::deployit_homedir,
  $deployit_user        = $deployit::deployit_user,
  $deployit_group       = $deployit::deployit_group,
  $deployit_admin       = $deployit::deployit_admin,
  $deployit_password    = $deployit::deployit_password,
  $deployit_http_port   = $deployit::deployit_http_port,
  $deployit_jcr_repository_path      = $deployit::deployit_jcr_repository_path,
  $deployit_ssl         = $deployit::deployit_ssl,
  $deployit_http_bind_address        = $deployit::deployit_http_bind_address,
  $deployit_http_context_root        = $deployit::deployit_http_context_root,
  $deployit_threads_max = $deployit::deployit_threads_max,
  $deployit_threads_min = $deployit::deployit_threads_min,
  $deployit_importable_packages_path = $deployit::deployit_importable_packages_path) {
  # variable setting
  $deployit_password_b64 = encode_b64("${deployit_password}")

  # flow control
  File["${deployit_homedir}/server/conf/deployit.conf"] -> Exec["init deployit"] ->
  Ini_setting['deployit http port', 
  'deployit jcr repository path', 
  'deployit threads min', 
  'deployit ssl', 
  'deployit http bind address',
  'deployit http context root',
  'deployit threads max',
  'deployit importable packages path']

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

  #  file { "${deployit_homedir}/server/conf/deployit.conf": content => inline_template("<% server_conf_options.sort_by {|key,
  #  value| key}.each do |key, value| %><%= key %>=<%= value %> \n<% end %>"
  #    ) }
  file { "${deployit_homedir}/server/conf/deployit.conf":
    content => template("deployit/deployit.conf.erb"),
    replace => false
  }

  exec { "init deployit":
    creates   => "${deployit_homedir}/server/repository",
    command   => "${deployit_homedir}/server/bin/server.sh -setup -reinitialize -force -repository-keystore-password ${deployit_password}",
    logoutput => true,
    user      => $deployit_user
  }

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

}