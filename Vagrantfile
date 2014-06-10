#
# Pulling out all the stops with cluster of seven Vagrant boxes.
#
domain   = 'coetzee.com'
box      =  'centos65-x86_64_2'
url      = 'http://files.vagrantup.com/precise32.box'


nodes = [
#  { :hostname => 'master',     :ip => '192.168.0.41', :box => box, :ram => 1024 },
  { :hostname => 'common',     :ip => '192.168.0.42', :box => box, :ram => 512 },
  { :hostname => 'jira',       :ip => '192.168.0.43', :box => box, :ram => 2048  },
  { :hostname => 'crowd',      :ip => '192.168.0.47', :box => box, :ram => 1024  },
  { :hostname => 'stash',      :ip => '192.168.0.44', :box => box, :ram => 1024  },
  { :hostname => 'fisheye',    :ip => '192.168.0.45', :box => box, :ram => 2048  },
  { :hostname => 'confluence', :ip => '192.168.0.46', :box => box, :ram => 2048  },
  { :hostname => 'bamboo',     :ip => '192.168.0.48', :box => box, :ram => 1024  },
]

Vagrant.configure("2") do |config|
  
   config.vm.define "master" do |c|
    c.vm.box = box
    c.vm.box_url = url
    c.vm.host_name = 'master.'+domain
    c.vm.provision :puppet do |puppet|
      	puppet.manifests_path = 'puppet/manifests'
    	puppet.manifest_file = 'site.pp'
    	puppet.module_path = 'puppet/modules'
    	puppet.hiera_config_path = "hiera.yaml"
    	puppet.working_directory = "/vagrant"
    end
    
    config.vm.provision :shell do |shell|
        shell.inline = "
            #rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm           
                        
            if [ ! -d /etc/puppet/modules/puppetdb ];
            then
                puppet module install puppetlabs-puppetdb
            fi
            
            if [ ! -d /etc/puppet/modules/jdk7 ];
		 		then
		 			puppet module install -f biemond-jdk7
		 	fi
		 		
            
            "
    end
    
    c.vm.network :forwarded_port, guest: 5432, host: 15432
    c.vm.network :forwarded_port, guest: 8080, host: 18080
    config.vm.network "private_network", ip: "192.168.0.41"
  end 
  
  
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
  end
  
end
