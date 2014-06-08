# Example 7
#
# Pulling out all the stops with cluster of seven Vagrant boxes.
#
domain   = 'coetzee.com'

nodes = [
  { :hostname => 'common',     :ip => '192.168.0.42', :box => 'centos65-x86_64_2', :ram => 512 },
  { :hostname => 'jira',       :ip => '192.168.0.43', :box => 'centos65-x86_64_2', :ram => 2048  },
  { :hostname => 'crowd',      :ip => '192.168.0.47', :box => 'centos65-x86_64_2', :ram => 1024  },
  { :hostname => 'stash',      :ip => '192.168.0.44', :box => 'centos65-x86_64_2', :ram => 1024  },
  { :hostname => 'fisheye',    :ip => '192.168.0.45', :box => 'centos65-x86_64_2', :ram => 2048  },
  { :hostname => 'confluence', :ip => '192.168.0.46', :box => 'centos65-x86_64_2', :ram => 2048  },
  { :hostname => 'bamboo',     :ip => '192.168.0.48', :box => 'centos65-x86_64_2', :ram => 1024  },
]

Vagrant::Config.run do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"
      node_config.vm.host_name = node[:hostname] + '.' + domain
      node_config.vm.network :hostonly, node[:ip]

      memory = node[:ram] ? node[:ram] : 256;
#      node_config.vm.customize [
#        'modifyvm', :id,
#        '--name', node[:hostname],
#        '--memory', memory.to_s
#      ]
      
        config.vm "virtualbox" do |v|
        v.customize[
            'modifyvm', :id,
            '--name', node[:hostname],
            '--memory', memory.to_s
          ]
      end
      
    end
  end
  
  config.vm.provision :shell do |shell|
 	shell.inline = "
 		if [ ! -d /etc/puppet/modules/jdk7 ];
 		then
 			puppet module install -f biemond-jdk7
 		fi
 		
 		if [ ! -d /etc/puppet/modules/nfs ];
 		then
 			puppet module install haraldsk-nfs
 		fi
 		
# 		if [ ! -d /etc/puppet/modules/users ];
# 		then
# 			puppet module install mthibaut-users
#		fi
 		
 		if [ ! -d /etc/puppet/modules/mysql ];
 		then
 			puppet module install puppetlabs-mysql
 		fi
 		
 		"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/vagrant"
  end
end
