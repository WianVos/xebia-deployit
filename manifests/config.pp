class deployit::config (
  $deployit_homedir       = $deployit::deployit_homedir,
  $deployit_user          = $deployit::deployit_user,
  $deployit_group         = $deployit::deployit_group,
  $deployit_admin         = $deployit::deployit_admin,
  $deployit_password      = $deployit::deployit_password,
  $deployit_password_hash = $deployit::deployit_password_hash,
  $deployit_http_port     = $deployit::deployit_http_port,
  $deployit_jcr_repository_path      = $deployit::deployit_jcr_repository_path,
  $deployit_ssl           = $deployit::deployit_ssl,
  $deployit_http_bind_address        = $deployit::deployit_http_bind_address,
  $deployit_http_context_root        = $deployit::deployit_http_context_root,
  $deployit_threads_max   = $deployit::deployit_threads_max,
  $deployit_threads_min   = $deployit::deployit_threads_min,
  $deployit_importable_packages_path = $deployit::deployit_importable_packages_path) {
  # variable setting
  # get the options into a hash


  #  $server_conf_options = {
  #    'admin.password' => "${deployit_password}",
  #    'jcr.repository.path'      => "${deployit_jcr_repository_path}",
  #    'threads.min'    => "${deployit_threads_min}",
  #    'ssl'            => "${deployit_ssl}",
  #    'threads.max'    => "${deployit_threads_max}",
  #    'http.bind.address'        => "${deployit_http_bind_address}",
  #    'http.context.root'        => "${deployit_http_context_root}",
  #    'http.port'      => "${deployit_http_port}",
  #    'importable.packages.path' => "${deployit_importable_packages_path}"
  #  }

  # flow control
  File["${deployit_homedir}/server/conf/deployit.conf"] -> Exec["init deployit"]

  # resource default settings
  File {
    owner  => $deployit_user,
    group  => $deployit_group,
    ensure => present,
    mode   => 750
  }

  # resources

  #  file { "${deployit_homedir}/server/conf/deployit.conf": content => inline_template("<% server_conf_options.sort_by {|key,
  #  value| key}.each do |key, value| %><%= key %>=<%= value %> \n<% end %>"
  #    ) }
  file { "${deployit_homedir}/server/conf/deployit.conf": content => template("deployit/deployit.conf.erb") }

  exec { "init deployit":
    creates   => "${deployit_homedir}/server/repository",
    command   => "${deployit_homedir}/server/bin/server.sh -setup -reinitialize -force -repository-keystore-password ${deployit_password}",
    logoutput => true,
    user => $deployit_user
  }
}