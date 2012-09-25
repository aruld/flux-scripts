#!/bin/bash

# start-workflow.sh - Starts a workflow from repository.

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
url="http://localhost:7186/cluster/repositoryFlowCharts/start?namespace=$slash_encoded"

echo "Starting workflow '$name' from repository..."
response=$(curl --silent -d "namespace=$slash_encoded" --user 'admin:admin' $url)

if [ $response -eq 1 ]
then
echo "Done starting $name!"
else
echo "Failed to start workflow $name!"
fi

trap - INT