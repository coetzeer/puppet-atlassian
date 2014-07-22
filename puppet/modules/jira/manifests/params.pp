class jira::params () {
  $user = 'jira'
  $atlassian_home = "/var/${user}"
  $installation_base_dir = '/opt/atlassian'
  
  $do_nfs = true
  $nfs_share = "/common_data/${user}"
  $nfs_mount ='/atlassian_home'
  $nfs_server = 'common.coetzee.com'
  $uid = undef
  $group = 'atlassian'
  $gid = '20001'
  $max_memory = '2048m'
  $min_memory = '1024m'
  $direct_nfs_folder = 'data'
  $mysql_connector = 'mysql-connector-java-5.1.31'
  $mysql_server = 'common.coetzee.com'

  class { 'apache::params': }

}