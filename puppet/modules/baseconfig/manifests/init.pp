# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {


  host {
    'common':
      ip => '192.168.0.42';

    'jira':
      ip => '192.168.0.43';

    'crowd':
      ip => '192.168.0.47';

    'stash':
      ip => '192.168.0.44';

    'fisheye':
      ip => '192.168.0.45';

    'confluence':
      ip => '192.168.0.46';

    'bamboo':
      ip => '192.168.0.47';

  }
  
  jdk7::install7{ 'jdk1.8.0':
    version              => "8u5" , 
    fullVersion          => "jdk1.8.0_05",
    alternativesPriority => 19000, 
    x64                  => true,
    downloadDir          => "/data/install",
    urandomJavaFix       => true,
    rsakeySizeFix        => false,
    sourcePath           => "/vagrant/binaries",
    javaHomes            => '/usr/java',
  }

}
