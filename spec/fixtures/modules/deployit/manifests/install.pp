# Class deployit::install
#
# Install the deployit server
class deployit::install (
  $deployit_homedir = $deployit::deployit_homedir,
  $deployit_basedir = $deployit::deployit_basedir,
  $deployit_group   = $deployit::deployit_group,
  $deployit_user    = $deployit::deployit_user,
  $deployit_version = $deployit::deployit_version,
  $tmpdir           = $deployit::tmpdir,
  $server_zipfile   = $deployit::server_zipfile,
  $cli_zipfile      = $deployit::cli_zipfile) {
  # # flow control

  Exec['unpack server file', 'unpack cli file']
  -> File['/etc/deployit', '/var/log/deployit']
  -> File['init script']

  # # resource defaults

  File {
    owner  => $deployit_user,
    group  => $deployit_group,
    ensure => present
  }

  Exec {
    cwd       => $tmpdir,
    user      => $deployit_user,
    logoutput => true
  }

  # # resources

  # # exec
  # unzip server file
  exec { 'unpack server file':
    command => "/usr/bin/unzip ${tmpdir}/${server_zipfile};
                /bin/cp -rp ${tmpdir}/deployit-${deployit_version}-server/* \
                ${deployit_basedir}/server/",
    creates => "${deployit_basedir}/server/bin"
  }

  # ... and cli packages
  exec { 'unpack cli file':
    command => "/usr/bin/unzip ${tmpdir}/${cli_zipfile};
                /bin/cp -rp ${tmpdir}/deployit-${deployit_version}-cli/* \
                ${deployit_basedir}/cli/",
    creates => "${deployit_basedir}/cli/bin"
  }

  # # files
  # convenience links
  # link the config file to a for unix admins
  # understandable path in the filesystem
  file { '/etc/deployit':
    ensure => link,
    target => "${deployit_homedir}/server/conf";
  }

  # link the log dir to a for unix admins ......... get it ?
  file { '/var/log/deployit':
    ensure => link,
    target => "${deployit_homedir}/server/log";
  }

  # put the init script in place
  # the template uses the following variables
  # deployit::deployit_user
  # deployit::deployit_homedir
  # deployit::deployit_password
  file { 'init script':
    content => template('deployit/deployit_initd.erb'),
    path    => '/etc/init.d/deployit',
    owner   => root,
    group   => root,
    mode    => '0700'
  }
}