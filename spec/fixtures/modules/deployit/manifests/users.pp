# class deployit::users
#
# This class take care of basic deployit server user and group creation
#
class deployit::users (
  $deployit_user    = $deployit::deployit_user,
  $deployit_group   = $deployit::deployit_group,
  $deployit_homedir = $deployit::deployit_homedir) {

  # flow control

  # input validation

  # resources

  # create the deployit needed user and group
  group { $deployit_group: ensure => present }

  user { $deployit_user:
    ensure => present,
    home   => $deployit_homedir,
    gid    => $deployit_group,
    system => true
  }

}