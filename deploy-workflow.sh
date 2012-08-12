#!/bin/bash

# deploy-workflow.sh - Exports a workflow to engine from XML (.ffc) file.

if [ $# -ne 2 ]
then
  echo "Usage: `basename $0` namespace ffcFilename"
  exit
fi

trap ctrl_c INT

function ctrl_c() {
        echo "`basename $0`: Caught CTRL-C, aborting..."
        exit 1
}

namespace=$1
filename=$2

CLASSPATH=flux.jar
for jar in lib/*.jar
do
  CLASSPATH=$CLASSPATH:$jar
done

java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin pause "$namespace" | tail -2
java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin interrupt "$namespace" | tail -2
java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin remove "$namespace" | tail -2

java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin export "$filename" | tail -2

trap - INT
