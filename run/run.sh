#!/bin/bash

source ./env.sh

# update the submit script
RUN_DIR=$PANTHEON_RUN_DIR

if [ -d $RUN_DIR ]; then
    echo "$RUN_DIR exists ... exiting"
    exit
fi

mkdir $RUN_DIR

cp env.sh $RUN_DIR
cp -rf pantheon $RUN_DIR
cp inputs/ascent/* $RUN_DIR
cp inputs/sw4/* $RUN_DIR
cp inputs/* $RUN_DIR
pushd $RUN_DIR
sed -i "s/<pantheon_workflow_jid>/${PANTHEON_WORKFLOW_JID}/" submit.sh
sed -i "s#<pantheon_workflow_dir>#${PANTHEON_WORKFLOW_DIR}#" submit.sh
bsub submit.sh

