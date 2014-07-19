# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {
  jdk7::install7 { 'jdk1.8.0':
    version              => "8u5",
    fullVersion          => "jdk1.8.0_05",
    alternativesPriority => 19000,
    x64                  => true,
    downloadDir          => "/data/install",
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

  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

}
