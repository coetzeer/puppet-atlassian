# create a new run stage to ensure certain modules are included first
stage { 'pre': before => Stage['main'] }

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# all boxes get the base config
include baseconfig

node 'common' {
  include common

  common::conf { 'common_stuff': export => "/common_data" }

}

node 'jira' {
  common::user { 'jira':
    username => 'jira',
    uid      => '20001'
  }
  
  common::nfs { '/common_data':
    base_dir => '/common_data',
    group => 'atlassian'
  }
  
  
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

node 'confluence' {
  common::user { 'confluence':
    username => 'stash',
    uid      => '20005'
  }
}

node 'bamboo' {
  common::user { 'bamboo':
    username => 'bamboo',
    uid      => '20006'
  }
}

