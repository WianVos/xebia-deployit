require 'spec_helper'

describe 'deployit' do
  it do 
    should include_class('deployit::users')
    should include_class('deployit::prereq')
    should include_class('deployit::download')
    should include_class('deployit::install')
    should include_class('deployit::config') 
    should include_class('deployit::service')
  end
  
  context 'with development => true' do
    let(:params) { {:development => true } }
    it do
      should include_class('deployit::development')
    end
  end
end
