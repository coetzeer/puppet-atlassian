class jira::params () {
  $nfs_share = '/common_data/jira'
  $atlassian_home = '/atlassian_home'
  $nfs_server = 'common.coetzee.com'
  $uid = undef
  $user = 'jira'
  $group = 'atlassian'
  $gid = '20001'
  $max_memory = '2048m'
  $min_memory = '1024m'

  class { 'apache::params': }

}