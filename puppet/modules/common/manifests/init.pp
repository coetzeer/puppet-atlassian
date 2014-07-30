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
  $mysql_root_passwd = 'descartes',
  $export            = '/common_data',
  $owner             = 'root',
  $group             = 'atlassian',
  $gid               = '20001') {
  class { 'apache':
    mpm_module    => 'prefork',
    default_vhost => false,
  }

  apache::vhost { $fqdn:
    port    => '80',
    docroot => "/vagrant/puppet/binaries",
  # custom_fragment => template('phabricator/apache-vhost-default.conf.erb'),
  }

  # TODO inject listen address from top
  class { '::mysql::server':
    root_password    => $mysql_root_passwd,
    override_options => {
      'mysqld' => {
        'max_connections'        => '1024',
        'bind-address'           => $::ipaddress_eth1,
        'transaction-isolation'  => 'READ-COMMITTED',
        'default-storage-engine' => 'INNODB',
        'character-set-server'   => 'utf8',
        'collation-server'       => 'utf8_bin',
        'max_allowed_packet'     => '32M',
      }
    }
  }

  group { $group:
    name   => $group,
    ensure => present,
    gid    => $gid
  }

  class { 'common::nfs_server':
    export => $export,
    owner  => $owner,
    group  => $group
  }

  class { 'common::conf':
    export         => $export,
    confluence_uid => $confluence_uid,
    jira_uid       => $jira_uid,
    fisheye_uid    => $fisheye_uid,
    crowd_uid      => $crowd_uid,
    stash_uid      => $stash_uid,
    bamboo_uid     => $bamboo_uid,
    group          => $group,
    gid            => $gid,
    require        => [Class['common::nfs_server'], Class['::mysql::server']]
  }

}
