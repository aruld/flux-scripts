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
space_encoded=${name// /%20}
slash_encoded=${space_encoded////%2F}
url="http://localhost:7186/cluster/repositoryFlowCharts/download?namespace=$slash_encoded"

echo "Downloading workflow '$name' from repository..."
curl -s -S --user 'admin:admin' -O -J -L $url
echo "Done downloading $name!"

trap - INT

