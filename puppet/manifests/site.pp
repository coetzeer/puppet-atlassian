# create a new run stage to ensure certain modules are included first
stage { 'pre':
  before => Stage['main']
}

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# all boxes get the base config
include baseconfig

node 'common' {
  include common
  
  common::conf{'common_stuff':
    export => "/common_data"
  }
  
}

node 'jira' {
  #include nginx, nginx_vhosts
}

node 'crowd' {
  #include nginx, nginx_vhosts
}

node 'stash' {
  #include nginx, nginx_vhosts
}

node 'fisheye' {
  #include nginx, nginx_vhosts
}

node 'confluence' {
  #include nginx, nginx_vhosts
}

node 'bamboo' {
  #include nginx, nginx_vhosts
}

