class confluence::post_installation (
  $user            = $confluence::params::user,
  $group           = $confluence::params::group,
  $max_memory      = $confluence::params::max_memory,
  $min_memory      = $confluence::params::min_memory,
  $mysql_server    = $confluence::params::mysql_server,
  $mysql_connector = $confluence::params::mysql_connector) inherits confluence::params {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

  archive { $mysql_connector:
    ensure     => present,
    src_target => '/tmp',
    url        => 'http://192.168.2.42/mysql-connector-java-5.1.31.tar.gz',
    target     => '/opt',
    checksum   => false
  }

  file { '/usr/share/java/': ensure => directory, } ->
  file { '/usr/share/java/mysql-connector-java.jar':
    source  => "/opt/${mysql_connector}/${mysql_connector}-bin.jar",
    ensure  => 'link',
    require => Archive[$mysql_connector],
  }

  file { "/opt/atlassian/confluence/lib/mysql-connector-java.jar":
    source  => "/usr/share/java/mysql-connector-java.jar",
    group   => $group,
    owner   => $user,
    links   => follow,
    require => File['/usr/share/java/mysql-connector-java.jar'],
  }

  file { "/opt/atlassian/confluence/confluence/WEB-INF/lib/mysql-connector-java.jar":
    source  => "/usr/share/java/mysql-connector-java.jar",
    group   => $group,
    owner   => $user,
    links   => follow,
    require => File['/usr/share/java/mysql-connector-java.jar'],
  }

  file { "/opt/atlassian/confluence/lib/mail-1.4.5.jar":
    source => "/opt/atlassian/confluence/confluence/WEB-INF/lib/mail-1.4.5.jar",
    group  => $group,
    owner  => $user,
  }


  augeas { 'tomcat_context':
    changes => 'set /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context/#attribute/path confluence',
    incl    => '/opt/atlassian/confluence/conf/server.xml',
    lens    => 'Xml.lns',
  }

  augeas { 'confluence_tomcat_context_db':
    changes => [
      'ins Resource after /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context[#attribute/path = "confluence"]/Manager',
      'defvar Resource /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context[#attribute/path = "confluence"]/Resource[1]',
      'set $Resource/#attribute/name "jdbc/ConfluenceDS"',
      'set $Resource/#attribute/type "javax.sql.DataSource"',
      'set $Resource/#attribute/driverClassName "com.mysql.jdbc.Driver"',
      "set \$Resource/#attribute/url \"jdbc:mysql://${mysql_server}:3306/confluence&useUnicode=true&characterEncoding=utf8\"",
      'set $Resource/#attribute/maxActive "20"',
      'set $Resource/#attribute/validationQuery "select 1"',
      'set $Resource/#attribute/username "confluence"',
      'set $Resource/#attribute/password "confluence"',
      ],
    incl    => '/opt/atlassian/confluence/conf/server.xml',
    lens    => 'Xml.lns',
    onlyif  => 'match /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute[name="jdbc/ConfluenceDS"] size == 0'
  }

  augeas { 'confluence_tomcat_context_mail':
    changes => [
      'ins Resource after /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context[#attribute/path = "confluence"]/Manager',
      'defvar Resource /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context[#attribute/path = "confluence"]/Resource[1]',
      'set $Resource/#attribute/name "mail/SmtpServer"',
      'set $Resource/#attribute/type "javax.mail.Session"',
      'set $Resource/#attribute/auth "Container"',
      "set \$Resource/#attribute/mail.smtp.host \"common.coetzee.com\"",
      'set $Resource/#attribute/mail.smtp.port "25"',
      ],
    incl    => '/opt/atlassian/confluence/conf/server.xml',
    lens    => 'Xml.lns',
    onlyif  => 'match /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Engine/Host/Context/Resource/#attribute[name="mail/SmtpServer"] size == 0'
  }

  augeas { 'proxy_connector':
    changes => [
      'ins Connector after /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Connector[last()]',
      'defvar Connector /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Connector[last()]',
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
    incl    => '/opt/atlassian/confluence/conf/server.xml',
    lens    => 'Xml.lns',
    onlyif  => 'match /files/opt/atlassian/confluence/conf/server.xml/Server/Service/Connector/#attribute[port="8081"] size == 0'
  }

  file_line { 'confluence_memory':
    path   => '/opt/atlassian/confluence/bin/setenv.sh',
    line   => "JAVA_OPTS=\"-Xms${min_memory} -Xmx${max_memory} -XX:MaxPermSize=256m \$JAVA_OPTS -Djava.awt.headless=true \"",
    match  => '^JAVA_OPTS=.*$',
    ensure => present,
  }

}