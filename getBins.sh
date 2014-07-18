#!/bin/bash -e
           

mkdir -p /vagrant/puppet/binaries 

function get_binary {
	cd /vagrant/puppet/binaries
   if [ ! -f $1 ];
    then
        wget $2
    fi
}


get_binary mysql-connector-java-5.1.31.tar.gz http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.31.tar.gz
get_binary atlassian-jira-6.3.1-x64.bin http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.3.1-x64.bin
get_binary atlassian-confluence-5.5.3-x64.bin http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.5.3-x64.bin
get_binary atlassian-stash-3.1.3-x64.bin http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-3.1.3-x64.bin
get_binary atlassian-bamboo-5.5.1.tar.gz http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.5.1.tar.gz
get_binary crucible-3.4.5.zip http://www.atlassian.com/software/crucible/downloads/binary/crucible-3.4.5.zip
get_binary atlassian-crowd-2.7.2.tar.gz http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-2.7.2.tar.gz
