#!/bin/bash

# download-workflow.sh - Download a workflow XML (.ffc) file from repository.

if [ $# -lt 1 ]
then
  echo "Usage: `basename $0` namespace"
  exit
fi

trap ctrl_c INT

function ctrl_c() {
        echo "`basename $0`: Caught CTRL-C, aborting..."
        exit 1
}

name=$1
url="http://localhost:7186/cluster/repositoryFlowCharts/download?namespace=%2F$name"
echo "url is $url"

#if [ $# -eq 1 ]
#then
        echo "Downloading workflow '$name' from repository..."
	curl --user 'admin:admin' -O -J -L $url
echo "Done downloading $name!"
#fi

trap - INT

