class deployit::download (
  $tmpdir           = $deployit::tmpdir,
  $install_source   = $deployit::install_source,
  $deployit_version = $deployit::deployit_version) {
  
  
  # # variable setting

  # # flow control
  case $install_source {
    'nexus' : { class{"deployit::download::nexusinstall":} -> Class[Deployit::Download] }
    'puppetfiles' : { class{"deployit::download::puppetfiles":} -> Class[Deployit::Download] }
    default : { notice("no valid installation method found") }
  } 
 
}