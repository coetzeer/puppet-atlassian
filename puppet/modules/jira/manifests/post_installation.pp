class jira::post_installation (
  $user            = $jira::params::user,
  $group           = $jira::params::group,
  $max_memory      = $jira::params::max_memory,
  $min_memory      = $jira::params::min_memory,
  $mysql_server    = $jira::params::mysql_server,
  $mysql_connector = $jira::params::mysql_connector) inherits jira::params {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

  archive { $mysql_connector:
    ensure     => present,
    src_target => '/tmp',
    url        => 'http://192.168.2.42/mysql-connector-java-5.1.31.tar.gz',
    target     => '/opt',
    checksum   => false
  }

  file { '/usr/share/java/mysql-connector-java.jar':
    source  => "/opt/${mysql_connector}/${mysql_connector}-bin.jar",
    ensure  => 'link',
    require => Archive[$mysql_connector],
  }

  file { "/opt/atlassian/jira/lib/mysql-connector-java.jar":
    source  => "/usr/share/java/mysql-connector-java.jar",
    group   => $group,
    owner   => $user,
    links   => follow,
    require => File['/usr/share/java/mysql-connector-java.jar'],
  }

  file { "/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/mysql-connector-java.jar":
    source  => "/usr/share/java/mysql-connector-java.jar",
    group   => $group,
    owner   => $user,
    links   => follow,
    require => File['/usr/share/java/mysql-connector-java.jar'],
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

  augeas { 'jira_tomcat_context':
    changes => 'set /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/#attribute/path jira',
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
  }

  augeas { 'jira_tomcat_context_db':
    changes => [
      'ins Resource after /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'defvar Resource /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'set $Resource/#attribute/name "jdbc/JiraDS"',
      'set $Resource/#attribute/type "javax.sql.DataSource"',
      'set $Resource/#attribute/driverClassName "com.mysql.jdbc.Driver"',
      "set \$Resource/#attribute/url \"jdbc:mysql://${mysql_server}:3306/jira\"",
      'set $Resource/#attribute/maxActive "20"',
      'set $Resource/#attribute/validationQuery "select 1"',
      'set $Resource/#attribute/username "jira"',
      'set $Resource/#attribute/password "jira"',
      ],
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
    onlyif  => 'match /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute[name="jdbc/JiraDS"] size == 0'
  }

  augeas { 'jira_tomcat_context_mail':
    changes => [
      'ins Resource after /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'defvar Resource /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource[last()]',
      'set $Resource/#attribute/name "mail/SmtpServer"',
      'set $Resource/#attribute/type "javax.mail.Session"',
      'set $Resource/#attribute/auth "Container"',
      "set \$Resource/#attribute/mail.smtp.host \"common.coetzee.com\"",
      'set $Resource/#attribute/mail.smtp.port "25"',
      ],
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
    onlyif  => 'match /files/opt/atlassian/jira/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute[name="mail/SmtpServer"] size == 0'
  }

  augeas { 'proxy_connector':
    changes => [
      'ins Connector after /files/opt/atlassian/jira/conf/server.xml/Server/Service/Connector[last()]',
      'defvar Connector /files/opt/atlassian/jira/conf/server.xml/Server/Service/Connector[last()]',
      'set $Connector/#attribute/acceptCount "100"',
      'set $Connector/#attribute/connectionTimeout "20000"',
      'set $Connector/#attribute/disableUploadTimeout "true"',
      'set $Connector/#attribute/enableLookups "true"',
      'set $Connector/#attribute/maxHttpHeaderSize "8192"',
      'set $Connector/#attribute/maxThreads "150"',
      'set $Connector/#attribute/minSpareThreads "25"',
      'set $Connector/#attribute/port "8081"',
      'set $Connector/#attribute/protocol "HTTP/1.1"',
      'set $Connector/#attribute/redirectPort "8443"',
      'set $Connector/#attribute/useBodyEncodingForURI "true"',
      "set \$Connector/#attribute/proxyName \"${fqdn}\"",
      'set $Connector/#attribute/proxyPort "80"',
      ],
    incl    => '/opt/atlassian/jira/conf/server.xml',
    lens    => 'Xml.lns',
    onlyif  => 'match /files/opt/atlassian/jira/conf/server.xml/Server/Service/Connector/#attribute[port="8081"] size == 0'
  }

  file_line { 'jira_min_memory':
    path   => '/opt/atlassian/jira/bin/setenv.sh',
    line   => "JVM_MINIMUM_MEMORY=\"${min_memory}\"",
    match  => '^JVM_MINIMUM_MEMORY=.*$',
    ensure => present,
  }

  file_line { 'jira_max_memory':
    path   => '/opt/atlassian/jira/bin/setenv.sh',
    line   => "JVM_MAXIMUM_MEMORY=\"${max_memory}\"",
    match  => '^JVM_MAXIMUM_MEMORY=.*$',
    ensure => present,
  }

}