# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {

#  jdk7::install7 { 'jdk1.8.0_u5':
#    version              => "8u5",
#    fullVersion          => "jdk1.8.0_05",
#    alternativesPriority => 18000,
#    x64                  => true,
#    downloadDir          => "/data/install8_5",
#    urandomJavaFix       => true,
#    rsakeySizeFix        => false,
#    sourcePath           => "/vagrant/puppet/binaries",
#    javaHomes            => '/usr/java',
#  }

  jdk7::install7 { 'jdk1.8.0_u11':
    version              => "8u11",
    fullVersion          => "jdk1.8.0_11",
    alternativesPriority => 19000,
    x64                  => true,
    downloadDir          => "/data/install5_u11",
    urandomJavaFix       => true,
    rsakeySizeFix        => false,
    sourcePath           => "/vagrant/puppet/binaries",
    javaHomes            => '/usr/java',
  }

  package { 'mutt': }

  class { '::ntp': servers => ['0.ie.pool.ntp.org', '1.ie.pool.ntp.org', '3.ie.pool.ntp.org', '4.ie.pool.ntp.org'], }

  class { 'timezone':
    region   => 'Europe',
    locality => 'Dublin',
  }

#  class { 'epel':
#    epel_proxy => 'absent'
#  }

  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

}
