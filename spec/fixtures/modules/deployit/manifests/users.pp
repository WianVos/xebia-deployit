class deployit::users (
  $deployit_user    = $deployit::deployit_user,
  $deployit_group   = $deployit::deployit_group,
  $deployit_homedir = $deployit::deployit_homedir) {
  
  # flow control

  # input validation

  # resources

  group { $deployit_group: ensure => present, }

  user { $deployit_user:
    ensure => present,
    home   => $deployit_homedir,
    gid    => $deployit_group,
    system => true
  }

}