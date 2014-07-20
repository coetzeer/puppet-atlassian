#
# $share should be one of /common_data/jira, /common_data/confluence, etc
#
define common::nfs_client (
  $share    = $title,
  $base_dir = '/atlassian_home',
  $group    = 'atlassian',
  $server   = 'common.coetzee.com',
  $owner    = undef) {
#  file { $base_dir:
#    group  => $group,
#    ensure => directory,
#    # recurse => true,
#    owner  => $owner,
#  }

  nfs::client::mount { $base_dir:
    mount   => $base_dir,
    server  => $server,
    share   => $share,
    atboot  => true,
    options => 'rsize=8192,wsize=8192,timeo=14,intr,rw'
  }

}