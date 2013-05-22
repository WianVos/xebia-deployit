# Class deployit::prereq
#
# This class manages the prerquisites for deployit.
class deployit::prereq (
  $deployit_homedir = $deployit::deployit_homedir,
  $deployit_basedir = $deployit::deployit_basedir,
  $deployit_group   = $deployit::deployit_group,
  $deployit_user    = $deployit::deployit_user,
  $tmpdir           = $deployit::tmpdir,
  $deployit_version = $deployit::deployit_version) {
  # # input validation

  # # variable setting

  # we need some xtra packages depending on the os family
  # TODO: Add ubuntu
  case $::osfamily {
    'RedHat' : { $xtra_packages = ['unzip', 'java-1.6.0-openjdk'] }
    'Debian' : { $xtra_packages = ['unzip'] }
    default  : { $xtra_packages = ['unzip'] }
  }

  # # flow control

  File[$tmpdir]
    -> File[$deployit_basedir,
            "${deployit_basedir}/server",
            "${deployit_basedir}/cli"]
    -> File['basedir to homedir']
    -> Package[$xtra_packages]

  # # resource defaults
  File {
    owner  => $deployit_user,
    group  => $deployit_group,
    ensure => directory,
    mode   => 700
  }

  Package {
    ensure => present }

  # # resources

  # files

  # create a temporary directory where the installation files will be places
  file { $tmpdir: }

  # create the deployit basedir and /server and /cli
  # the installation will go here ..
  file { [$deployit_basedir,
          "${deployit_basedir}/server",
          "${deployit_basedir}/cli"]: }

  # link the basedir to the homedir.
  # so /opt/deployit_3.8.5 will link to /opt/deployit
  file { 'basedir to homedir':
    ensure => link,
    path   => $deployit_homedir,
    target => $deployit_basedir
  }

  # packages
  # installs the xtra packages derived from the case statement earlier
  package { $xtra_packages: }

}