class confluence (
  $nfs_share      = '/common_data/confluence',
  $atlassian_home = '/atlassian_home',
  $nfs_server     = 'common.coetzee.com',
  $uid            = undef,
  $group          = 'atlassian',
  $gid            = '20001') {
  $user = 'confluence'

  group { $group:
    name   => $group,
    ensure => present,
    gid    => $gid
  } ->
  baseconfig::user { $user:
    username => $user,
    uid      => $uid
  }

  baseconfig::nfs_client { $nfs_share:
    base_dir => $atlassian_home,
    server   => $nfs_server,
    owner    => $user,
    require  => [User[$user]]
  }

}