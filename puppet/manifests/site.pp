# create a new run stage to ensure certain modules are included first
stage { 'pre': before => Stage['main'] }

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# all boxes get the base config
include baseconfig

$confuence_uid = '20002'
$jira_uid = '20001'
$fisheye_uid = '20003'
$crowd_uid = '20004'
$stash_uid = '20005'
$bamboo_uid = '20006'

node 'common' {
  class { 'common':
    confluence_uid => $confuence_uid,
    jira_uid       => $jira_uid,
    fisheye_uid    => $fisheye_uid,
    crowd_uid      => $crowd_uid,
    stash_uid      => $stash_uid,
    bamboo_uid     => $bamboo_uid,
  }

}

node 'jira' {
  class { 'jira': uid => $jira_uid }

}

node 'confluence' {
  class { 'confluence': uid => $confuence_uid }
}

node 'crowd' {
  baseconfig::user { 'crowd':
    username => 'crowd',
    uid      => '20004'
  }
}

node 'stash' {
  
   class { 'stash': uid => $stash_uid }
}

node 'fisheye' {
  baseconfig::user { 'fisheye':
    username => 'stash',
    uid      => '20003'
  }
}

node 'bamboo' {
  baseconfig::user { 'bamboo':
    username => 'bamboo',
    uid      => '20006'
  }
}

