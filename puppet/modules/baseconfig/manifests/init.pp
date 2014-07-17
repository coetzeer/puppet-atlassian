# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {
  
  jdk7::install7{ 'jdk1.8.0':
    version              => "8u5" , 
    fullVersion          => "jdk1.8.0_05",
    alternativesPriority => 19000, 
    x64                  => true,
    downloadDir          => "/data/install",
    urandomJavaFix       => true,
    rsakeySizeFix        => false,
    sourcePath           => "/vagrant/puppet/binaries",
    javaHomes            => '/usr/java',
  }


}
