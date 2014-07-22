class jira (
  $user                  = $jira::params::user,
  $atlassian_home        = $jira::params::atlassian_home,
  $installation_base_dir = $jira::params::installation_base_dir,
  $do_nfs                = $jira::params::do_nfs,
  $nfs_share             = $jira::params::nfs_share,
  $nfs_mount             = $jira::params::nfs_mount,
  $nfs_server            = $jira::params::nfs_server,
  $uid                   = $jira::params::uid,
  $group                 = $jira::params::group,
  $gid                   = $jira::params::gid,
  $max_memory            = $jira::params::max_memory,
  $min_memory            = $jira::params::min_memory,
  $direct_nfs_folder     = $jira::params::direct_nfs_folder,) inherits jira::params {
  
  class { 'jira::pre_installation':
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

  file { "${installation_base_dir}/response.varfile":
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

  baseconfig::remote_file { "/opt/atlassian/${user}.bin":
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
    command => "pkill -u jira1 java",
    require => Exec["install $user"],
    onlyif  => ["test 0 -ne ` pgrep -u jira1 java | wc -l`"]
  }

  user { 'jira1':
    ensure  => absent,
    require => Exec["stop $user"],
  }

  file { "/opt/atlassian/jira/lib/mysql-connector-java-5.1.31.jar":
    source  => "/opt/mysql-connector-java-5.1.31/mysql-connector-java-5.1.31-bin.jar",
    group   => $group,
    owner   => $user,
    require => [Exec["install $user"], Archive['mysql-connector-java-5.1.31']],
  }

  file { "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/mysql-connector-java-5.1.31.jar":
    source  => "/opt/mysql-connector-java-5.1.31/mysql-connector-java-5.1.31-bin.jar",
    group   => $group,
    owner   => $user,
    require => [Exec["install $user"], Archive['mysql-connector-java-5.1.31']],
  }

  file { "/opt/atlassian/jira/lib/mail-1.4.5.jar":
    source  => "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/mail-1.4.5.jar",
    group   => $group,
    owner   => $user,
    require => Exec["install $user"],
  }

  file { "/opt/atlassian/jira/lib/activation-1.1.1.jar":
    source  => "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/activation-1.1.1.jar",
    group   => $group,
    owner   => $user,
    require => Exec["install $user"],
  }

  file { "/etc/init.d/${user}":
    ensure  => present,
    content => template('jira/init.erb'),
    owner   => $user,
    group   => $group,
    mode    => 755,
    require => Exec["install $user"],
  }

  service { $user:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    require    => [File["/etc/init.d/${user}"], Exec["stop $user"]],
  }

  augeas { 'jira_tomcat_context':
    changes => 'set /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/#attribute/path jira',
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
    notify  => Service["jira"],
    require => Exec["install $user"],
  }

  augeas { 'jira_tomcat_context_db':
    changes => [
      'ins Resource after /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'defvar Resource /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'set $Resource/#attribute/name "jdbc/JiraDS"',
      'set $Resource/#attribute/type "javax.sql.DataSource"',
      'set $Resource/#attribute/driverClassName "com.mysql.jdbc.Driver"',
      'set $Resource/#attribute/url "jdbc:mysql://common.coetzee.com:3306/jira',
      'set $Resource/#attribute/maxActive "20"',
      'set $Resource/#attribute/validationQuery "select 1"',
      'set $Resource/#attribute/username "jira"',
      'set $Resource/#attribute/password "jira"',
      ],
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
    notify  => Service["jira"],
    require => Exec["install $user"],
    onlyif  => 'match /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute/name not_include  jdbc/JiraDS'
  }

  augeas { 'jira_tomcat_context_mail':
    changes => [
      'ins Resource after /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'defvar Resource /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'set $Resource/#attribute/name "mail/SmtpServer"',
      'set $Resource/#attribute/type "javax.mail.Session"',
      'set $Resource/#attribute/auth "Container"',
      'set $Resource/#attribute/mail.smtp.host "common.coetzee.com"',
      'set $Resource/#attribute/mail.smtp.port "25"',
      ],
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
    notify  => Service["jira"],
    require => Exec["install $user"],
    onlyif  => 'match /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute/name not_include  mail/SmtpServer'
  }

  # TODO externalize and inject memory args here

  file_line { 'jira_min_memory':
    path    => '/opt/atlassian/jira/bin/setenv.sh',
    line    => "JVM_MINIMUM_MEMORY=\"${min_memory}\"",
    match   => '^JVM_MINIMUM_MEMORY=.*$',
    ensure  => present,
    require => Exec["install $user"],
  }

  file_line { 'jira_max_memory':
    path    => '/opt/atlassian/jira/bin/setenv.sh',
    line    => "JVM_MAXIMUM_MEMORY=\"${max_memory}\"",
    match   => '^JVM_MAXIMUM_MEMORY=.*$',
    ensure  => present,
    require => Exec["install $user"],
  }

  #  augeas { 'jira_memory_args':
  #    changes => [
  #      'set /file/opt/atlassian/jira/bin/setenv.sh/JVM_MINIMUM_MEMORY "1024"',
  #      'set /file/opt/atlassian/jira/bin/setenv.sh/JVM_MAXIMUM_MEMORY "2048"',
  #      ],
  #    incl    => 'opt/atlassian/jira/bin/setenv.sh',
  #    lens    => 'Shellvars.lns',
  #    notify  => Service["jira"],
  #    require => Exec["install $user"],
  #    #onlyif  => 'match /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute/name
  #    not_include  mail/SmtpServer'
  #  }
}