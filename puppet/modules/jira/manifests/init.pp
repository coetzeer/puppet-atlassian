class jira (
  $nfs_share      = '/common_data/jira',
  $atlassian_home = '/atlassian_home',
  $nfs_server     = 'common.coetzee.com',
  $uid            = undef) {
  $user = 'jira'
  $group = 'atlassian'

  common::user { $user:
    username => $user,
    uid      => $uid
  }

  common::nfs { $nfs_share:
    base_dir => $atlassian_home,
    server   => $nfs_server,
    owner    => $user,
    require  => [User[$user]]
  }

  file { "/opt/atlassian":
    group   => $group,
    owner   => $user,
    ensure  => directory,
    recurse => true,
    require => User[$user]
  }

  file { "/var/${user}":
    group   => $group,
    owner   => $user,
    ensure  => directory,
    recurse => true,
    require => User[$user]
  }

  file { "${$atlassian_home}/data":
    group   => $group,
    owner   => $user,
    ensure  => directory,
    recurse => true,
    require => User[$user]
  }

  file { "/var/${user}/data":
    ensure => 'link',
    target => "${$atlassian_home}/data",
  }

  cron { 'sync_data':
    command => "rsync -r --exclude 'data' /var/${user}/* ${$atlassian_home}",
    minute  => '*/5',
  }

  file { "/opt/atlassian/response.varfile":
    ensure  => present,
    content => template('jira/response_file.erb'),
    owner   => $user,
    group   => $group,
    mode    => 755,
  }

  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

  archive { 'mysql-connector-java-5.1.31':
    ensure     => present,
    src_target => '/tmp',
    url        => 'http://192.168.2.42/mysql-connector-java-5.1.31.tar.gz',
    target     => '/opt',
  }

  common::remote_file { "/opt/atlassian/${user}.bin":
    remote_location => "http://192.168.2.42/atlassian-jira-6.3.1-x64.bin",
    mode            => "700",
    group           => $group,
    owner           => $user,
  }

  exec { "install $user":
    command => "/opt/atlassian/${user}.bin -q -varfile /opt/atlassian/response.varfile",
    creates => "/opt/atlassian/${user}",
    require => File["/opt/atlassian/${user}.bin"],
    user    => "${user}"
  }

  exec { "stop $user":
    command => "pkill java",
    require => Exec["install $user"],
  }

  user { 'jira1':
    ensure  => absent,
    require => Exec["stop $user"],
  }

  file { "/opt/atlassian/jira/lib/mysql-connector-java-5.1.31.jar":
    source => "/opt/mysql-connector-java-5.1.31/mysql-connector-java-5.1.31-bin.jar",
    group  => $group,
    owner  => $user,
  }

  file { "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/mysql-connector-java-5.1.31.jar":
    source => "/opt/mysql-connector-java-5.1.31/mysql-connector-java-5.1.31-bin.jar",
    group  => $group,
    owner  => $user,
  }

  file { "/opt/atlassian/jira/lib/mail-1.4.5.jar":
    source => "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/mail-1.4.5.jar",
    group  => $group,
    owner  => $user,
  }

  file { "/opt/atlassian/jira/lib/activation-1.1.1.jar":
    source => "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/activation-1.1.1.jar",
    group  => $group,
    owner  => $user,
  }

  file { "/etc/init.d/${user}":
    ensure  => present,
    content => template('jira/init.erb'),
    owner   => $user,
    group   => $group,
    mode    => 755,
  }

  service { $user:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => File["/etc/init.d/${user}"],
  }

}