require 'spec_helper'

describe 'deployit::config' do
  let(:params) {{ :deployit_homedir     => '/opt/deployit',
      :deployit_user        => 'deployit',
      :deployit_group       => 'deployit',
      :deployit_admin       => 'admin',
      :deployit_password    => 'admin',
      :deployit_http_port   => '4516',
      :deployit_jcr_repository_path      => 'repository',
      :deployit_ssl         => 'false',
      :deployit_http_bind_address        => '0.0.0.0',
      :deployit_http_context_root        => '/',
      :deployit_threads_max => '24',
      :deployit_threads_min => '4',
      :deployit_importable_packages_path => 'plugins' }}

  it  do
    should contain_file('/opt/deployit/server/conf/deployit.conf').with('owner' => 'deployit', 'group' => 'deployit', 'ensure' => 'present', 'mode' => '750')
    should contain_file('install plugins').with(
     'owner' => 'deployit',
     'group' => 'deployit',
     'ensure' => 'present',
     'mode' => '750',
     'source' => "puppet:///modules/deployit/plugins/",
     'sourceselect' => 'all',
     'recurse'      => 'remote',
     'path'         => "/opt/deployit/server/plugins" )
    should contain_ini_setting('deployit http port').with('setting' => 'http.port'  ,'value' => '4516' )
    should contain_ini_setting('deployit jcr repository path').with('setting' => 'jcr.repository.path'  ,'value' => 'repository' )
    should contain_ini_setting('deployit threads min').with('setting' => 'threads.min' ,'value' => '4' )
    should contain_ini_setting('deployit ssl').with('setting' => 'ssl' ,'value' => 'false' )
    should contain_ini_setting('deployit http bind address').with('setting' => 'http.bind.address'  ,'value' => '0.0.0.0' )
    should contain_ini_setting('deployit http context root').with('setting' => 'http.context.root' ,'value' => '/' )
    should contain_ini_setting('deployit threads max').with('setting' => 'threads.max' ,'value' => '24' )
    should contain_ini_setting('deployit importable packages path').with('setting' => 'importable.packages.path' ,'value' => 'plugins' )
    should contain_exec('init deployit').with(
     'creates'   => "/opt/deployit/server/repository",
     'command'   => '/opt/deployit/server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/deployit/server/conf/deployit.conf',
     'logoutput' => 'true',
     'user'      => 'deployit')

  end

end