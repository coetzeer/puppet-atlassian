#
# Pulling out all the stops with cluster of seven Vagrant boxes.
#
domain   = 'coetzee.com'
box      =  'centos65-x86_64_3'
url      = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box'


nodes = [
  { :hostname => 'common',     :ip => '192.168.2.42', :box => box, :ram => 512 },
  { :hostname => 'jira',       :ip => '192.168.2.43', :box => box, :ram => 2048  },
  { :hostname => 'crowd',      :ip => '192.168.2.47', :box => box, :ram => 1024  },
  { :hostname => 'stash',      :ip => '192.168.2.44', :box => box, :ram => 1024  },
  { :hostname => 'fisheye',    :ip => '192.168.2.45', :box => box, :ram => 2048  },
  { :hostname => 'confluence', :ip => '192.168.2.46', :box => box, :ram => 2048  },
  { :hostname => 'bamboo',     :ip => '192.168.2.48', :box => box, :ram => 1024  },
]

Vagrant.configure("2") do |config|
  
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
	      node_config.vm.box = node[:box]
	      node_config.vm.box_url = url
	      node_config.vm.host_name = node[:hostname] + '.' + domain
	      config.vm.network "private_network", ip: node[:ip]
	
	      memory = node[:ram] ? node[:ram] : 256;
	     
	      config.vm "virtualbox" do |v|
	      v.customize[
	          'modifyvm', :id,
	          '--name', node[:hostname],
	          '--memory', memory.to_s
	        ]
	        

	        
	     end

		 config.vm.provision "shell", path: "provision.sh"

		 config.vm.provision :puppet do |puppet|
	      	puppet.manifests_path = 'puppet/manifests'
	    	puppet.manifest_file = 'site.pp'
	    	puppet.module_path = 'puppet/modules'
	    	puppet.working_directory = "/vagrant"
	    	puppet.options = " --debug"
	    end

      
    end
  end
  
end
