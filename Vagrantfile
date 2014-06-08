# Example 7
#
# Pulling out all the stops with cluster of seven Vagrant boxes.
#
domain   = 'coetzee.com'

nodes = [
  { :hostname => 'common',     :ip => '192.168.0.42', :box => 'centos65-x86_64_1', :ram => 512 },
  { :hostname => 'jira',       :ip => '192.168.0.43', :box => 'centos65-x86_64_1', :ram => 2048  },
  { :hostname => 'stash',      :ip => '192.168.0.44', :box => 'centos65-x86_64_1', :ram => 1024  },
  { :hostname => 'fisheye',    :ip => '192.168.0.45', :box => 'centos65-x86_64_1', :ram => 2048  },
  { :hostname => 'confluence', :ip => '192.168.0.46', :box => 'centos65-x86_64_1', :ram => 2048  },
  { :hostname => 'crowd',      :ip => '192.168.0.47', :box => 'centos65-x86_64_1', :ram => 1024  },
  { :hostname => 'bamboo',     :ip => '192.168.0.48', :box => 'centos65-x86_64_1', :ram => 1024  },
]

Vagrant::Config.run do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.host_name = node[:hostname] + '.' + domain
      node_config.vm.network :hostonly, node[:ip]

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.customize [
        'modifyvm', :id,
        '--name', node[:hostname],
        '--memory', memory.to_s
      ]
    end
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
  end
end
