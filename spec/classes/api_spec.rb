require 'spec_helper'

describe 'salt::api', :type => 'class' do

  ['Debian', 'RedHat', 'SUSE', 'ArchLinux' ].each do |distro|
    context "on #{distro}" do
      let(:facts) {{
          :osfamily => distro,
          :concat_basedir => '/tmp'
      }}

      [ 'cherrypy', 'tornado', 'wsgi' ].each do |api|
        context "with the #{api} api enabled" do
          let (:params) { { "api_enable_#{api}".to_sym => true } }

          it { should contain_package('salt-api') }

          it { should contain_service('salt-api').with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasstatus'  => 'true',
            'hasrestart' => 'true'
          )}

          it { should contain_concat__fragment('api')
            .with({ :target => '/etc/salt/master'})
          }

          it { should contain_concat('/etc/salt/master')
            .with_content(/^rest_#{api}:/)
          }


        end
      end

    end
  end
end
