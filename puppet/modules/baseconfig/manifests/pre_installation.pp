class baseconfig::pre_installation (
  $user                  = undef,
  $atlassian_home        = undef,
  $installation_base_dir = undef,
  $do_nfs                = true,
  $nfs_share             = undef,
  $nfs_mount             = undef,
  $nfs_server            = undef,
  $uid                   = undef,
  $group                 = undef,
  $gid                   = undef,
  $direct_nfs_folder     = undef,) {
    
  group { $group:
    name   => $group,
    ensure => present,
    gid    => $gid
  } ->
  baseconfig::user { $user:
    username => $user,
    uid      => $uid
  }

  file { $installation_base_dir:
    group   => $group,
    owner   => $user,
    ensure  => directory,
    # recurse => true,
    require => User[$user]
  }

  file { $atlassian_home:
    group   => $group,
    owner   => $user,
    ensure  => directory,
    recurse => true,
    require => User[$user]
  }

  if ($do_nfs) {
    baseconfig::nfs_client { $nfs_share:
      base_dir => $nfs_mount,
      server   => $nfs_server,
      owner    => $user,
      require  => [User[$user]]
    }

    if ($direct_nfs_folder) {
      file { "${atlassian_home}/${direct_nfs_folder}":
        ensure  => 'link',
        target  => "${nfs_mount}/${direct_nfs_folder}",
        require => File["${nfs_mount}/${direct_nfs_folder}"]
      }

      file { "${nfs_mount}/${direct_nfs_folder}":
        group   => $group,
        owner   => $user,
        ensure  => directory,
        recurse => true,
        require => User[$user]
      }

      cron { "sync ${atlassian_home} to ${nfs_mount} ":
        command => "rsync -r --exclude '${direct_nfs_folder}' ${atlassian_home}/* ${nfs_mount}",
        minute  => '*/5',
      }
    } else {
      cron { "sync ${atlassian_home} to ${nfs_mount} ":
        command => "rsync -r ${atlassian_home}/* ${nfs_mount}",
        minute  => '*/5',
      }
    }

  }

}