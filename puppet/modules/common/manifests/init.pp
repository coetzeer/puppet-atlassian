# == Class: common
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class common (
  $confluence_uid    = undef,
  $jira_uid          = undef,
  $fisheye_uid       = undef,
  $crowd_uid         = undef,
  $stash_uid         = undef,
  $bamboo_uid        = undef,
  $mysql_root_passwd = 'descartes') {
  
  
  class { 'apache':
    mpm_module    => 'prefork',
    default_vhost => false,
  }

  apache::vhost { $fqdn:
    port    => '80',
    docroot => "/vagrant/puppet/binaries",
  # custom_fragment => template('phabricator/apache-vhost-default.conf.erb'),
  }

  class { '::mysql::server':
    root_password    => $mysql_root_passwd,
    override_options => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }

  class { 'common::conf':
    confluence_uid => $confluence_uid,
    jira_uid       => $jira_uid,
    fisheye_uid    => $fisheye_uid,
    crowd_uid      => $crowd_uid,
    stash_uid      => $stash_uid,
    bamboo_uid     => $bamboo_uid,
  }

}
