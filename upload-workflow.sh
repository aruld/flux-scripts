#!/bin/bash

# upload-workflow.sh - Uploads a workflow to repository from XML (.ffc) file.

if [ $# -lt 1 ]
then
  echo "Usage: `basename $0` ffcFilename namespace"
  exit
fi

trap ctrl_c INT

function ctrl_c() {
        echo "`basename $0`: Caught CTRL-C, aborting..."
        exit 1
}

filename=$1
namespace=$2

if [ $# -eq 2 ]
then
        echo "Uploading workflow $filename to namespace $namespace..."
        curl -F "file=@$filename;filename=$namespace" --user 'admin:admin' http://localhost:7186/cluster/repositoryFlowCharts/upload
        echo "Done uploading $filename!"
else
        echo "Uploading workflow $filename ..."
        curl -F "file=@$filename" --user 'admin:admin' http://localhost:7186/cluster/repositoryFlowCharts/upload
        echo "Done uploading $filename!"
fi

trap - INT

