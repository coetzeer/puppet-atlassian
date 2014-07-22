class jira::pre_installation (
  $user                  = $jira::params::user,
  $atlassian_home        = $jira::params::atlassian_home,
  $installation_base_dir = $jira::params::installation_base_dir,
  $do_nfs                = $jira::params::do_nfs,
  $nfs_share             = $jira::params::nfs_share,
  $nfs_mount             = $jira::params::nfs_mount,
  $nfs_server            = $jira::params::nfs_server,
  $uid                   = $jira::params::uid,
  $group                 = $jira::params::group,
  $gid                   = $jira::params::gid,
  $direct_nfs_folder     = $jira::params::direct_nfs_folder,) {
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