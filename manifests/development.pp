class deployit::development{
  
  file {'/root/development':
    ensure => directory,
    recurse => true,
    mode => 700,
    source => "puppet:///modules/deployit/development"
  }
}