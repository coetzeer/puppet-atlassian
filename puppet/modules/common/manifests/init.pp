# == Class: common
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class common ($confluence_uid = undef, $jira_uid = undef, $mysql_root_passwd = 'descartes') {
  class { '::mysql::server':
    root_password    => $mysql_root_passwd,
    override_options => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }

  class { 'common::conf':
    confluence_uid => $confluence_uid,
    jira_uid       => $jira_uid,
  }

}
