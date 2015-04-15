require 'spec_helper'

describe 'salt', :type => 'class' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it 'should fail' do
      expect { should compile }.to raise_error(/Unsupported platform: Unsupported/)
    end
  end

  ['Debian', 'RedHat', 'SUSE', 'ArchLinux' ].each do |distro|
    context "on #{distro}" do
      let(:facts) {{
          :osfamily => distro,
          :concat_basedir => '/tmp'
        }}

      it { should contain_class('salt::master::install') }
      it { should contain_class('salt::master::config') }
      it { should contain_class('salt::master::service') }
      it { should contain_class('salt::minion::install') }
      it { should contain_class('salt::minion::config') }
      it { should contain_class('salt::minion::service') }

      describe 'with default params' do
        it { should contain_file('/etc/salt/master')}
        it { should contain_file('/etc/salt/minion')}

        it { should contain_service('salt-master').with(
          'ensure'     => 'running',
          'enable'     => 'true',
          'hasstatus'  => 'true',
          'hasrestart' => 'true'
          )}

        it { should contain_service('salt-minion').with(
          'ensure'     => 'running',
          'enable'     => 'true',
          'hasstatus'  => 'true',
          'hasrestart' => 'true'
          )}

        ## ArchLinux has different package names
        case distro
        when 'ArchLinux'
          master_package = 'salt'
          minion_package = 'salt'
        else
          master_package = 'salt-master'
          minion_package = 'salt-minion'
        end

        it 'should install the salt master package' do
          should contain_package(master_package).with(
          'ensure'   => 'present',
          'name'     => master_package
          )
        end

        it 'should install the salt minion package' do
          should contain_package(minion_package).with(
          'ensure'   => 'present',
          'name'     => minion_package
          )
        end
      end

    end
  end
end
