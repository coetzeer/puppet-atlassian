# create a new run stage to ensure certain modules are included first
stage { 'pre': before => Stage['main'] }

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# all boxes get the base config
include baseconfig

$confuence_uid = '20005'
$jira_uid = '20001'

node 'common' {
  class { 'common':
    confluence_uid => $confuence_uid,
    jira_uid       => $jira_uid,
  }

}

node 'jira' {
  class { 'jira': uid => $jira_uid }

}

node 'confluence' {
  class { 'confluence': uid => $confuence_uid }
}

node 'crowd' {
  common::user { 'crowd':
    username => 'crowd',
    uid      => '20004'
  }
}

node 'stash' {
  common::user { 'stash':
    username => 'stash',
    uid      => '20005'
  }
}

node 'fisheye' {
  common::user { 'fisheye':
    username => 'stash',
    uid      => '20003'
  }
}

node 'bamboo' {
  common::user { 'bamboo':
    username => 'bamboo',
    uid      => '20006'
  }
}

