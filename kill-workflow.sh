#!/bin/bash

# kill-workflow.sh - Removes all workflows under a provided namespace

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` namespace"
  exit
fi

namespace=$1

trap ctrl_c INT

function ctrl_c() {
        echo "`basename $0`: Caught CTRL-C, aborting..."
        exit 1
}

CLASSPATH=flux.jar
for jar in lib/*.jar
do
  CLASSPATH=$CLASSPATH:$jar
done

echo "Sizing $namespace..."
activeCount=$(java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin size "$namespace" | tail -1 | awk '{ print $3 }')
echo "There are $activeCount workflows in $namespace"

if [ $activeCount -gt 0 ]
then
	echo "Pausing $namespace..."
	java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin pause "$namespace" | tail -2

	echo "Interrupting $namespace..."
	java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin interrupt "$namespace" | tail -2

	echo "Removing $namespace..."
	java -classpath $CLASSPATH flux.Main client -cp config/engine-config.properties -username admin -password admin remove "$namespace" | tail -2

	echo "Done removing $namespace!"
else
	echo "Not removing anything $namespace."
fi

trap - INT
