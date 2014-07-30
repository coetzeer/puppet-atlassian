class confluence (
  $user                  = $confluence::params::user,
  $atlassian_home        = $confluence::params::atlassian_home,
  $installation_base_dir = $confluence::params::installation_base_dir,
  $do_nfs                = $confluence::params::do_nfs,
  $nfs_share             = $confluence::params::nfs_share,
  $nfs_mount             = $confluence::params::nfs_mount,
  $nfs_server            = $confluence::params::nfs_server,
  $uid                   = $confluence::params::uid,
  $group                 = $confluence::params::group,
  $gid                   = $confluence::params::gid,
  $max_memory            = $confluence::params::max_memory,
  $min_memory            = $confluence::params::min_memory,
  $direct_nfs_folder     = $confluence::params::direct_nfs_folder,
  $mysql_server          = $confluence::params::mysql_server,
  $mysql_connector       = $confluence::params::mysql_connector) inherits confluence::params {
  

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
    content => template('confluence/response_file.erb'),
    owner   => $user,
    group   => $group,
    mode    => 755,
  }

  baseconfig::remote_file { "/opt/atlassian/${user}.bin":
    remote_location => "http://192.168.2.42/atlassian-confluence-5.5.3-x64.bin",
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
    command => "pkill java",
    require => Exec["install $user"],
    onlyif  => ["test 0 -ne ` pgrep java | wc -l`"]
  }

  class { 'confluence::post_installation':
    user            => $user,
    group           => $group,
    max_memory      => $max_memory,
    min_memory      => $min_memory,
    mysql_server    => $mysql_server,
    mysql_connector => $mysql_connector,
    require         => Exec["install $user"],
    notify          => Service[$user],
  }

  file { "/etc/init.d/${user}":
    ensure  => present,
    content => template("${user}/init.erb"),
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
        'path' => '/confluence',
        'url'  => "http://${fqdn}/confluence"
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