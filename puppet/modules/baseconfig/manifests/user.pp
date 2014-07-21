define baseconfig::user ($username = $title, $uid = undef, $group = 'atlassian',) {
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