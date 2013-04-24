require 'spec_helper'

describe 'deployit::prereq' do
  let(:params) {{ :deployit_homedir => '/opt/deployit',
      :deployit_basedir => '/opt/deployit_3.8.5',
      :deployit_group => 'deployit',
      :deployit_user => 'deployit',
      :tmpdir => '/var/tmp',
      :deployit_version => '3.8.5'
    }}

  it do
    should contain_file('/var/tmp').with('ensure' => 'directory' )
    should contain_file('/opt/deployit_3.8.5').with('ensure' => 'directory', 'owner' => 'deployit', 'group' => 'deployit', 'mode' => '700')
    should contain_file('/opt/deployit_3.8.5/server').with('ensure' => 'directory', 'owner' => 'deployit', 'group' => 'deployit', 'mode' => '700')
    should contain_file('/opt/deployit_3.8.5/cli').with('ensure' => 'directory', 'owner' => 'deployit', 'group' => 'deployit', 'mode' => '700')
    should contain_file('basedir to homedir').with('ensure' => 'link','path' => '/opt/deployit', 'target' => '/opt/deployit_3.8.5', 'owner' => 'deployit', 'group' => 'deployit', 'mode' => '700')
  end

  context 'with osfamily => redhat' do
    let(:facts) { {:osfamily => 'redhat' } }
    it do
      should contain_package('unzip').with_ensure('present')
      should contain_package('java-1.6.0-openjdk').with_ensure('present')
      should contain_package('rubygems').with_ensure('present')
      should contain_package('xml-simple').with('ensure' => 'present', 'provider' => 'gem')
      should contain_package('rest-client').with_ensure('present', 'provider' => 'gem')
    end
  end
  context 'with osfamily => ubuntu' do
    let(:facts) { {:osfamily => 'debian' } }
    it do
      should contain_package('unzip').with_ensure('present')
    end
  end

end
