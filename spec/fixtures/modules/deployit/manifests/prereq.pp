class deployit::prereq (
  $deployit_homedir = $deployit::deployit_homedir,
  $deployit_basedir = $deployit::deployit_basedir,
  $deployit_group   = $deployit::deployit_group,
  $deployit_user    = $deployit::deployit_user,
  $tmpdir           = $deployit::tmpdir,
  $deployit_version = $deployit::deployit_version) {
  # # input validation

  # # variable setting
  case $osfamily {
    'RedHat' : {
      $xtra_packages = ["unzip", "java-1.6.0-openjdk"]
      $xtra_gems = ["xml-simple", "rest-client", "mime-types"]
    }
    'Debian' : {
      $xtra_packages = ["unzip"]
    }
    default  : {
      $xtra_packages = ['unzip']
    }
  }
  # # flow control

  File["$tmpdir"] -> File["${deployit_basedir}", "${deployit_basedir}/server", "${deployit_basedir}/cli"] -> File["basedir to homedir"
    ] -> Package[$xtra_packages] -> Package[$xtra_gems]

  if $::pe_version != nil {
    Package[$xtra_packages] -> File["pe gem link"] -> Package[$xtra_gems]
  }

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


  file { "${tmpdir}": }

  file { ["${deployit_basedir}", "${deployit_basedir}/server", "${deployit_basedir}/cli"]: }

  file { "basedir to homedir":
    ensure => link,
    path   => "${deployit_homedir}",
    target => "${deployit_basedir}"
  }

  file { "pe gem link":
    ensure => link,
    path   => "/usr/sbin/gem",
    target => "/opt/puppet/bin/gem"
  }

  # packages
  package {
    $xtra_packages:
    ;

    $xtra_gems:
      provider => gem
  }

}