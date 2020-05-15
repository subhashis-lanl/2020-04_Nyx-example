#!/usr/bin/env python

import sys
import math
import os
import glob
import numpy as np
import argparse
import itertools
import csv
import json
import time
###############################################

## hardcoded: Fianlly these will come from user input JSON/yaml file
num_procs = [1,4]

## Read PANTHEON specific environment variables
ROOT_PANTHEONPATH =os.getenv("PANTHEONPATH")
ROOT_PANTHEON_WORKFLOW_DIR = os.getenv("PANTHEON_WORKFLOW_DIR")
ROOT_PANTHEON_RUN_DIR = os.getenv("PANTHEON_RUN_DIR")
ROOT_PANTHEON_DATA_DIR = os.getenv("PANTHEON_DATA_DIR")
ROOT_PANTHEON_WORKFLOW_ID = os.getenv("PANTHEON_WORKFLOW_ID")
ROOT_PANTHEON_WORKFLOW_JID = os.getenv("PANTHEON_WORKFLOW_JID") 

##Create folder for keeping all the generated scripts for param study
#script_path = ROOT_PANTHEON_WORKFLOW_DIR + '/scripts/'
#if not os.path.exists(script_path):
#    os.makedirs(script_path)
#else:
#    os.system('rm ' + script_path)

#Create job scripts with different parameter configurations
for i in num_procs:
	
	##uid is a unique id will be used to name the scripts. Currently using proc id
	uid = i
	
	## generate unique run directories
	UNIQUE_RUNDIR = ROOT_PANTHEON_RUN_DIR + '_' + str(uid) + '/'
	if os.path.exists(UNIQUE_RUNDIR):
		print ('Run directory exists, exiting...')
		sys.exit()
	else:
		os.makedirs(UNIQUE_RUNDIR)
	

	## Create submit script
	script_name = UNIQUE_RUNDIR + 'submit_' + str(uid) + '.sh'
	print ('generating script: ' + script_name)
	file = open(script_name,"w")
	
	file.write('#!/bin/bash\n\n') 
	
	unique_jid = ROOT_PANTHEON_WORKFLOW_JID + str(uid) 
	line = '#BSUB -J ' +  str(unique_jid) + '\n'
	file.write(line)
	line = '#BSUB -nnodes ' +  str(i) + '\n'
	file.write(line)
	line = '#BSUB -P ' +  'csc420' + '\n'
	file.write(line)
	line = '#BSUB -W ' +  '00:05' + '\n\n'
	file.write(line)

	line = 'module load gcc/6.4.0' + '\n'
	file.write(line)
	line = 'module load cmake/3.14.2' + '\n'
	file.write(line)
	line = 'module load hdf5/1.8.18' + '\n\n'
	file.write(line)

	line = 'jsrun -n ' + str(i) + ' ' + UNIQUE_RUNDIR + 'Nyx3d.gnu.PROF.MPI.ex inputs'
	file.write(line)
	
	file.close()
	

	## Copy support APP support files $PANTHEON_WORKFLOW_DIR/nyx/Nyx/Exec/LyA/* $RUN_DIR
	cp_command = 'cp -rf ' + ROOT_PANTHEON_WORKFLOW_DIR + '/nyx/Nyx/Exec/LyA/* ' + UNIQUE_RUNDIR
	os.system(cp_command)

	




