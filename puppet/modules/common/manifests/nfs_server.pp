#
# $share should be one of /common_data/jira, /common_data/confluence, etc
#
class common::nfs_server ($export = undef, $owner = undef, $group = undef) {
  file { $export:
    ensure => directory,
    owner  => $owner,
    group  => $group
  }

  include nfs::server

  nfs::server::export { $export:
    ensure  => 'mounted',
    clients => '192.168.0.0/16(rw,insecure,async,no_root_squash) localhost(rw)',
    require => File[$export],
  }

}