class stash (
  $user                  = $stash::params::user,
  $atlassian_home        = $stash::params::atlassian_home,
  $installation_base_dir = $stash::params::installation_base_dir,
  $do_nfs                = $stash::params::do_nfs,
  $nfs_share             = $stash::params::nfs_share,
  $nfs_mount             = $stash::params::nfs_mount,
  $nfs_server            = $stash::params::nfs_server,
  $uid                   = $stash::params::uid,
  $group                 = $stash::params::group,
  $gid                   = $stash::params::gid,
  $max_memory            = $stash::params::max_memory,
  $min_memory            = $stash::params::min_memory,
  $direct_nfs_folder     = $stash::params::direct_nfs_folder,
  $mysql_server          = $stash::params::mysql_server,
  $mysql_connector       = $stash::params::mysql_connector) inherits stash::params {
  
  class { 'baseconfig::pre_installation':
    user                  => $user,
    atlassian_home        => $atlassian_home,
    installation_base_dir => $installation_base_dir,
    do_nfs                => $do_nfs,
    nfs_share             => $nfs_share,
    nfs_mount             => $nfs_mount,
    nfs_server            => $nfs_server,
    uid                   => $uid,
    group                 => $group,
    gid                   => $gid,
    direct_nfs_folder     => $direct_nfs_folder
  }


class {'repoforge' :
  enabled     => ['rpmforge', 'extras'],
  includepkgs => { 'extras' => 'git-1.7.12.4-1.el6.rfx.x86_64' },
}

  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

#  file { "${installation_base_dir}/response.varfile":
#    ensure  => present,
#    content => template('stash/response_file.erb'),
#    owner   => $user,
#    group   => $group,
#    mode    => 755,
#  }
#
#  baseconfig::remote_file { "/opt/atlassian/${user}.bin":
#    remote_location => "http://192.168.2.42/atlassian-stash-3.1.3-x64.bin",
#    mode            => "700",
#    group           => $group,
#    owner           => $user,
#  }
#
#  exec { "install $user":
#    command => "/opt/atlassian/${user}.bin -q -varfile /opt/atlassian/response.varfile",
#    creates => "/opt/atlassian/${user}",
#    require => File["/opt/atlassian/${user}.bin"],
#    tries   => 5,
#    user    => "${user}"
#  }
#
#   exec { "stop $user":
#    command => "pkill java",
#    require => Exec["install $user"],
#    onlyif  => ["test 0 -ne ` pgrep java | wc -l`"]
#  }
#
#  class { 'stash::post_installation':
#    user            => $user,
#    group           => $group,
#    max_memory      => $max_memory,
#    min_memory      => $min_memory,
#    mysql_server    => $mysql_server,
#    mysql_connector => $mysql_connector,
#    require         => Exec["install $user"],
#    notify          => Service[$user],
#  }
#
#  file { "/etc/init.d/${user}":
#    ensure  => present,
#    content => template('stash/init.erb'),
#    owner   => $user,
#    group   => $group,
#    mode    => 755,
#    require => Class['baseconfig::pre_installation'],
#  }
#
#  service { $user:
#    ensure     => running,
#    enable     => true,
#    hasrestart => false,
#    hasstatus  => false,
#    require    => [File["/etc/init.d/${user}"], Exec["stop $user"]],
#  }
#
#  apache::vhost { $fqdn:
#    port            => '80',
#    proxy_pass      => [{
#        'path' => '/stash',
#        'url'  => "http://${fqdn}/stash"
#      }
#      ],
#    request_headers => ['unset Authorization',],
#    docroot => "/vagrant/puppet/binaries",
#    custom_fragment => 'ProxyPreserveHost       On'
#  }
#
#  class { 'apache':
#    mpm_module    => 'prefork',
#    default_vhost => false,
#  }

  #  apache::vhost { $fqdn:
  #    port    => '80',
  #    docroot => "/vagrant/puppet/binaries",
  #  ,
  #  }
}
