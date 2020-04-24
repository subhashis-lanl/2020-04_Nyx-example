#!/bin/bash

source pantheon_env.sh

time=-$(date +%s); 
while [ "$(bjobs 2>&1 | grep "$PANTHEON_WORKFLOW_JID")" ]; do 
  clear; 
  echo ===========================================; 
  echo ">>>  Job(s) running ($(( $(date +%s) + ${time} )) seconds elapsed)";
  echo ===========================================; bjobs; 
  sleep 5; 
done;
echo "Jobs have finished running. Move to validation stage."
