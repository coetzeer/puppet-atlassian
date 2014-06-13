# create a new run stage to ensure certain modules are included first
stage { 'pre': before => Stage['main'] }

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# all boxes get the base config
include baseconfig

node 'master' {
  

  class { 'puppetdb':
    
    listen_address   => '0.0.0.0',
    #ssl_listen_address => '0.0.0.0', 
    listen_port      => '8080',
    #ssl_listen_port => '8081',
    open_listen_port => true,
    open_ssl_listen_port => true,
    disable_ssl      => true
       
  }

  # Configure the puppet master to use puppetdb
  class { 'puppetdb::master::config':
    puppetdb_server => 'master',
    require => Class['puppetdb']
  }
  
  class { '::mysql::server':
    root_password    => 'descartes',
    override_options => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  } 
  
#  class { 'dashboard':
#    dashboard_ensure   => 'present',
#    dashboard_user     => 'puppet-dbuser',
#    dashboard_group    => 'puppet-dbgroup',
#    dashboard_password => 'changeme',
#    dashboard_db       => 'dashboard_prod',
#    dashboard_charset  => 'utf8',
#    dashboard_site     => $fqdn,
#    dashboard_port     => '3000',
#    mysql_root_pw      => 'descartes',
#    passenger          => true,
#    require => Class['::mysql::server']
#  }

}

node 'common' {
  include common

  common::conf { 'common_stuff': export => "/common_data" }

}

node 'jira' {
  common::user { 'jira':
    username => 'jira',
    uid      => '20001'
  }

  common::nfs { '/common_data':
    base_dir => '/common_data',
    group    => 'atlassian'
  }

}

node 'crowd' {
  common::user { 'crowd':
    username => 'crowd',
    uid      => '20004'
  }
}

node 'stash' {
  common::user { 'stash':
    username => 'stash',
    uid      => '20005'
  }
}

node 'fisheye' {
  common::user { 'fisheye':
    username => 'stash',
    uid      => '20003'
  }
}

node 'confluence' {
  common::user { 'confluence':
    username => 'stash',
    uid      => '20005'
  }
}

node 'bamboo' {
  common::user { 'bamboo':
    username => 'bamboo',
    uid      => '20006'
  }
}

