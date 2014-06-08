

define common::conf($export = '/common_data'){
  
  if !defined(File[$export]) {
    file { $export: ensure => directory, }
  }

  include nfs::server

  nfs::server::export { $export:
    ensure  => 'mounted',
    clients => '192.168.0.0/24(rw,async,no_root_squash) localhost(rw)',
    require => File[$export],
  }

  class { '::mysql::server':
    root_password    => 'descartes',
    override_options => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }
  
}