require 'spec_helper'

describe 'salt::master', :type => 'class' do

  ['Debian', 'RedHat', 'SUSE', 'ArchLinux' ].each do |distro|
    context "on #{distro}" do
      let(:facts) {{
          :osfamily => distro,
          :concat_basedir => '/tmp'
      }}

      [ 'cherrypy', 'tornado', 'wsgi' ].each do |api|
        context "with the #{api} api enabled" do
          let(:params) {{
            "api_enable_#{api}".to_sym => true
          }}

          it { should_not contain_file('/etc/salt/puppet') }
          it { should contain_concat__fragment('master')
            .with({
              :target => '/etc/salt/master',
              :order  => '01'
            })
          }
          it { should contain_concat__fragment('api')
            .with({
              :target => '/etc/salt/master',
              :order  => '02'
            })
          }
          it { should contain_conact('/etc/salt/master') }

        end
      end

    end
  end
end
