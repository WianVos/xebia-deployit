class deployit::download (
  $tmpdir           = $deployit::tmpdir,
  $install_source   = $deployit::install_source,
  $deployit_version = $deployit::deployit_version) {
  
  # this class is responsible for downloading the installation files 
  # there will be more methods availble shortly
  
  # # variable setting

  # # flow control
  
  case $install_source {
    'puppetfiles' : { class{"deployit::download::puppetfiles":} -> Class[Deployit::Download] }
    default : { notice("no valid installation method found") }
  } 
 
}