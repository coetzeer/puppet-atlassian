class jira (
  $user                  = $jira::params::user,
  $atlassian_home        = $jira::params::atlassian_home,
  $installation_base_dir = $jira::params::installation_base_dir,
  $do_nfs                = $jira::params::do_nfs,
  $nfs_share             = $jira::params::nfs_share,
  $nfs_mount             = $jira::params::nfs_mount,
  $nfs_server            = $jira::params::nfs_server,
  $uid                   = $jira::params::uid,
  $group                 = $jira::params::group,
  $gid                   = $jira::params::gid,
  $max_memory            = $jira::params::max_memory,
  $min_memory            = $jira::params::min_memory,
  $direct_nfs_folder     = $jira::params::direct_nfs_folder,
  $mysql_server          = $jira::params::mysql_server,
  $mysql_connector       = $jira::params::mysql_connector) inherits jira::params {
  
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

  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

  file { "${installation_base_dir}/response.varfile":
    ensure  => present,
    content => template('jira/response_file.erb'),
    owner   => $user,
    group   => $group,
    mode    => 755,
  }

  baseconfig::remote_file { "/opt/atlassian/${user}.bin":
    remote_location => "http://192.168.2.42/atlassian-jira-6.3.1-x64.bin",
    mode            => "700",
    group           => $group,
    owner           => $user,
  }

  exec { "install $user":
    command => "/opt/atlassian/${user}.bin -q -varfile /opt/atlassian/response.varfile",
    creates => "/opt/atlassian/${user}",
    require => File["/opt/atlassian/${user}.bin"],
    tries   => 5,
    user    => "${user}"
  }

  exec { "stop $user":
    command => "pkill -u jira1 java",
    require => Exec["install $user"],
    onlyif  => ["test 0 -ne ` pgrep -u jira1 java | wc -l`"]
  }

  user { 'jira1':
    ensure  => absent,
    require => Exec["stop $user"],
  }

  class { 'jira::post_installation':
    user            => $user,
    group           => $group,
    max_memory      => $max_memory,
    min_memory      => $min_memory,
    mysql_server    => $mysql_server,
    mysql_connector => $mysql_connector,
    require         => Exec["install $user"],
    notify          => Service["jira"],
  }

  file { "/etc/init.d/${user}":
    ensure  => present,
    content => template('jira/init.erb'),
    owner   => $user,
    group   => $group,
    mode    => 755,
    require => Class['baseconfig::pre_installation'],
  }

  service { $user:
    ensure     => running,
    enable     => true,
    hasrestart => false,
    hasstatus  => false,
    require    => [File["/etc/init.d/${user}"], Exec["stop $user"]],
  }

  apache::vhost { $fqdn:
    port            => '80',
    proxy_pass      => [{
        'path' => '/jira',
        'url'  => "http://${fqdn}/jira"
      }
      ],
    request_headers => ['unset Authorization',],
    docroot => "/vagrant/puppet/binaries",
    custom_fragment => 'ProxyPreserveHost       On'
  }

  class { 'apache':
    mpm_module    => 'prefork',
    default_vhost => false,
  }

  #  apache::vhost { $fqdn:
  #    port    => '80',
  #    docroot => "/vagrant/puppet/binaries",
  #  ,
  #  }
}
