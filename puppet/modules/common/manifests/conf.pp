
class common::conf (
  $export         = '/common_data',
  $owner          = 'root',
  $group          = 'atlassian',
  $jira_uid       = undef,
  $confluence_uid = undef,
  $fisheye_uid    = undef,
  $crowd_uid      = undef,
  $stash_uid      = undef,
  $bamboo_uid     = undef,) {
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

  common::user { 'jira':
    username => 'jira',
    uid      => $jira_uid
  }

  file { "${export}/jira":
    group   => 'atlassian',
    owner   => 'jira',
    ensure  => directory,
    require => [File[$export], User['jira']]
  }

  user { 'confluence':
    ensure           => present,
    name             => 'confluence',
    uid              => $confluence_uid,
    groups           => 'atlassian',
    password         => 'confluence',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

  file { "${export}/confluence":
    group   => 'atlassian',
    owner   => 'confluence',
    ensure  => directory,
    require => [File[$export], User['confluence']]
  }

  user { 'fisheye':
    ensure           => present,
    name             => 'fisheye',
    uid              => $fisheye_uid,
    groups           => 'atlassian',
    password         => 'fisheye',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

  file { "${export}/fisheye":
    group   => 'atlassian',
    owner   => 'fisheye',
    ensure  => directory,
    require => [File[$export], User['fisheye']]
  }

  user { 'crowd':
    ensure           => present,
    name             => 'crowd',
    uid              => $crowd_uid,
    groups           => 'atlassian',
    password         => 'crowd',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

  file { "${export}/crowd":
    group   => 'atlassian',
    owner   => 'crowd',
    ensure  => directory,
    require => [File[$export], User['crowd']]
  }

  user { 'stash':
    ensure           => present,
    name             => 'stash',
    uid              => $stash_uid,
    groups           => 'atlassian',
    password         => 'stash',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

  file { "${export}/stash":
    group   => 'atlassian',
    owner   => 'stash',
    ensure  => directory,
    require => [File[$export], User['stash']]
  }

  user { 'bamboo':
    ensure           => present,
    name             => 'bamboo',
    uid              => $bamboo_uid,
    groups           => 'atlassian',
    password         => 'bamboo',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

  file { "${export}/bamboo":
    group   => 'atlassian',
    owner   => 'bamboo',
    ensure  => directory,
    require => [File[$export], User['bamboo']]
  }

}