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

  file { "/var/jira":
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

  file { '/var/${user}/data':
    ensure => 'link',
    target => "${$atlassian_home}/data",
  }

}