define baseconfig::server_user ($username = $title, $uid = undef, $group = 'atlassian', $gid = '20001', $export = undef,) {
  baseconfig::user { $username:
    username => $username,
    uid      => $uid
  }

  file { "${export}/${username}":
    group   => $group,
    owner   => $username,
    ensure  => directory,
    require => User[$username]
  }
  
  #TODO externalize host here
  mysql::db { $username:
      user     =>  $username,
      password =>  $username,
      host     => "${username}.coetzee.com",
      grant    => ['ALL'],
    }

}