class deployit::development{
  
  # copy's some handy development files to a directory under the root's home
  file {'/root/development':
    ensure => directory,
    recurse => true,
    mode => 700,
    source => "puppet:///modules/deployit/development"
  }
}