class confluence ($nfs_share = '/common_data/confluence', $atlassian_home = '/atlassian_home', $nfs_server = 'common.coetzee.com', $uid=undef) {
  $user='confluence'
  
  common::user { $user:
    username => $user,
    uid      => $uid
  }

  common::nfs { $nfs_share:
    base_dir => $atlassian_home,
    server   => $nfs_server,
    owner    => $user,
    require => [User[$user]]
  }
  

}