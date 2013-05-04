# xebia-deployit 

 This puppet module can do one of two things
 it installs Xebialabs deployit for you 
 on top of that has a number of resources that will enable you 
 to add configuration items to deployit from anywhere in your infrastructure by using the deployit rest interface

## Versioning 
 this module is tested for 
 * Centos 6.4 & Deployit 3.8.5 & puppet enterprise 2.7 & 2.8

 

## Parameters: 

	*  deployit_user        					
		* the deployit user (which it will run under and indicates the login account)
	*  $deployit_group     						
		* the deployit unix group 
	*  $deployit_homedir    					
		* the directory under wich the installation can be fond
	*  $deployit_version    					
		* desired version (if multiple are available)
	*  $deployit_admin      					
		* the deployit admin user (deprecated)
	*  $deployit_password   
		* deployit password (under revision)
	*  $deployit_http_port  
		* the httpd port on wicht deployit will run
	*  $deployit_jcr_repository_path      
		* the path where the jcr repository will be kept
	*  $deployit_ssl         
		* use ssl (true/false) 
	*  $deployit_http_bind_address        
		* deployit httpd bind address 
	*  $deployit_http_context_root        
		* deployit http context root (default to /)
	*  $deployit_threads_max 
		* max java threads (defaults to 32)
	*  $deployit_threads_min 
		* min java threads (defautls to 4)
	*  $deployit_importable_packages_path 
		* importable packages path (defaults to importablepackages)
	*  $tmpdir               
		* temporary filesystem where the installfiles will be placed before installation
	*  $install_source       
		* installation method (defaults to puppetfiles)
	*  $development          
		* deprecated
	*  $load_ci              
		* deprecated 
	*  $server               
		* install server? true or false .. (defaults to false)
	*  $test                 
		* deprecated
		
## Actions: 
	
## Requires 

## Sample Usage 

## available types
*	deployit_core_directory
*	deployit_jetty_server
*	deployit_overthere_ssh_host
*	deployit_udm_dictionary
