define common::user (
  $username = $title, 
  $uid = undef, 
  $group = 'atlassian', 
  $gid = '20001'
) {
  
  group { "${username}_${group}" :
    name   => $group,
    ensure => present,
    gid    => $gid
  }

  user { $username:
    ensure           => present,
    name             => $username,
    uid              => $uid,
    groups           => $group,
    password         => $username,
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
  }

}