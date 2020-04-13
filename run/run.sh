#!/bin/bash

source ./env.sh

# update the submit script
RUN_DIR=$PANTHEON_RUN_DIR

if [ -d $RUN_DIR ]; then
    echo "$RUN_DIR exists ... exiting"
    exit
fi

mkdir $RUN_DIR

# copy input files
cp inputs/ascent/* $RUN_DIR
cp inputs/* $RUN_DIR

# copy executable
cp $PANTHEON_WORKFLOW_DIR/nyx/Nyx/Exec/LyA/Nyx3d.gnu.PROF.MPI.ex $RUN_DIR

# go to run dir and update the submit script
pushd $RUN_DIR

sed -i "s/<pantheon_workflow_jid>/${PANTHEON_WORKFLOW_JID}/" submit.sh
sed -i "s#<pantheon_workflow_dir>#${PANTHEON_WORKFLOW_DIR}#" submit.sh
sed -i "s#<pantheon_run_dir>#${RUN_DIR}#" submit.sh


# submit
bsub submit.sh

