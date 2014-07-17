class jira ($nfs_share = '/common_data/jira', $atlassian_home = '/atlassian_home', $nfs_server = 'common.coetzee.com', $uid=undef) {
  common::user { 'jira':
    username => 'jira',
    uid      => $uid
  }

  common::nfs { $nfs_share:
    base_dir => $atlassian_home,
    server   => $nfs_server,
    owner    => 'jira'
  }

}