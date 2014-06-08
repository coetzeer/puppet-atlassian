define common::nfs (
  $base_dir = '/common_data', 
  $group = 'atlassian'
) {
  
  file { $base_dir: 
    group   => $group,
    ensure  => directory,
  }
  
  
    include nfs::client
    
    Nfs::Client::Mount <<| |>> {
      ensure => 'mounted',
      mount  => $base_dir,
      require => [File[$base_dir]]  
    }
  
  
  

}