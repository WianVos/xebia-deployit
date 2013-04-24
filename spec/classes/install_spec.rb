require 'spec_helper'

describe 'deployit::install' do
  let(:params) {{ :deployit_homedir => '/opt/deployit',
      :deployit_basedir => '/opt/deployit_3.8.5',
      :deployit_group => 'deployit',
      :deployit_user => 'deployit',
      :tmpdir => '/var/tmp',
      :deployit_version => '3.8.5',
      :cli_zipfile => 'deployit-3.8.5-cli.zip',
      :server_zipfile => 'deployit-3.8.5-server.zip'
    }}

  it do
    should contain_exec('unpack server file').with('command' => '/usr/bin/unzip /var/tmp/deployit-3.8.5-server.zip; /bin/cp -rp /var/tmp/deployit-3.8.5-server/* /opt/deployit_3.8.5/server/',
      'creates' => '/opt/deployit_3.8.5/server/bin')
    should contain_exec('unpack cli file').with('command' => '/usr/bin/unzip /var/tmp/deployit-3.8.5-cli.zip; /bin/cp -rp /var/tmp/deployit-3.8.5-cli/* /opt/deployit_3.8.5/cli/',
      'creates' => '/opt/deployit_3.8.5/cli/bin')
    should contain_file('/etc/deployit').with('ensure' => 'link', 'target' => '/opt/deployit/server/conf')
    should contain_file('/var/log/deployit').with('ensure' => 'link', 'target' => '/opt/deployit/server/log')
    should contain_file('init script').with_content(/[RUNNINGUSER="deployit"]/)
    should contain_file('init script').with_content(/[DEPLOYIT_HOME="\/opt\/deployit\/server"]/)
    should contain_file('init script').with('path'    => '/etc/init.d/deployit',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '700')
  end

end

