require 'spec_helper'

describe 'deployit::users' do 
  let(:params) { {:deployit_user => "deployit", 
                  :deployit_group => "deployit",
                  :deployit_homedir => "/opt/deployit" 
  }}
    
  it  do 
    should contain_user('deployit').with(
      'ensure' => 'present',
      'home'   => '/opt/deployit',
      'gid'    => 'deployit',
      'system' => 'true' )
      
    should contain_group('deployit').with_ensure("present")
    
  end
end