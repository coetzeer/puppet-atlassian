
class common::conf (
  $export         = undef,
  $jira_uid       = undef,
  $confluence_uid = undef,
  $fisheye_uid    = undef,
  $crowd_uid      = undef,
  $stash_uid      = undef,
  $bamboo_uid     = undef,
  $group          = undef,
  $gid            = undef) {


  common::server_user { 'jira':
    uid    => $jira_uid,
    export => $export,
    group  => $group
  }

  common::server_user { 'confluence':
    uid    => $confluence_uid,
    export => $export,
    group  => $group
  }

  common::server_user { 'fisheye':
    uid    => $fisheye_uid,
    export => $export,
    group  => $group
  }

  common::server_user { 'crowd':
    uid    => $crowd_uid,
    export => $export,
    group  => $group
  }

  common::server_user { 'stash':
    uid    => $stash_uid,
    export => $export,
    group  => $group
  }

  common::server_user { 'bamboo':
    uid    => $bamboo_uid,
    export => $export,
    group  => $group
  }

}