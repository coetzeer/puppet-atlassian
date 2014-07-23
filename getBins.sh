#!/bin/bash

mkdir -p /vagrant/puppet/binaries 

function get_binary {
    cd /vagrant/puppet/binaries
	echo "checking for file $1"
    if [ ! -f $1 ];
    then
	echo "Downloading $1"
        wget $2 -O $1
    fi
}


get_binary mysql-connector-java-5.1.31.tar.gz http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.31.tar.gz
get_binary atlassian-jira-6.3.1-x64.bin http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.3.1-x64.bin
get_binary atlassian-confluence-5.5.3-x64.bin http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.5.3-x64.bin
get_binary atlassian-stash-3.1.3-x64.bin http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-3.1.3-x64.bin
get_binary atlassian-bamboo-5.5.1.tar.gz http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.5.1.tar.gz
#get_binary crucible-3.4.5.zip http://www.atlassian.com/software/crucible/downloads/binary/crucible-3.4.5.zip
#get_binary fisheye-3.5.0.zip http://downloads.atlassian.com/software/fisheye/downloads/fisheye-3.5.0.zip
get_binary crucible-3.5.0.zip http://downloads.atlassian.com/software/crucible/downloads/crucible-3.5.0.zip
get_binary atlassian-crowd-2.7.2.tar.gz http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-2.7.2.tar.gz

cd /vagrant/puppet/binaries
if [ ! -f jdk-7u60-linux-x64.tar.gz ]; 
then
	wget -O jdk-7u60-linux-x64.tar.gz --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-x64.tar.gz
fi

if [ ! -f jdk-8u5-linux-x64.tar.gz ]; 
then
	wget -O jdk-8u5-linux-x64.tar.gz --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.tar.gz
fi

if [ ! -f jdk-8u11-linux-x64.tar.gz ]; 
then
	wget -O jdk-8u11-linux-x64.tar.gz --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz
fi