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
from pyutil import filereplace
###############################################

## hardcoded: Fianlly these will come from user input JSON/yaml file
num_procs = [1,4]
phi = [2]
theta = [2]
exec_name = 'Nyx3d.gnu.PROF.MPI.ex'

## Read PANTHEON specific environment variables
ROOT_PANTHEONPATH =os.getenv("PANTHEONPATH")
ROOT_PANTHEON_WORKFLOW_DIR = os.getenv("PANTHEON_WORKFLOW_DIR")
ROOT_PANTHEON_RUN_DIR = os.getenv("PANTHEON_RUN_DIR")
ROOT_PANTHEON_DATA_DIR = os.getenv("PANTHEON_DATA_DIR")
ROOT_PANTHEON_WORKFLOW_ID = os.getenv("PANTHEON_WORKFLOW_ID")
ROOT_PANTHEON_WORKFLOW_JID = os.getenv("PANTHEON_WORKFLOW_JID") 

#Create job scripts with different parameter configurations
for param in itertools.product(num_procs,phi,theta):
	
	##uid is a unique id will be used to name the scripts.
	pid = param[0]
	phi_val = param[1]
	theta_val = param[2]
	
	## uid is a unique identifier used to create folders and files	
	uid = 'proc' + str(pid) + '_phi' + str(phi_val) + '_theta' + str(theta_val)
	
	## generate unique run directories
	UNIQUE_RUNDIR = ROOT_PANTHEON_RUN_DIR + '_' + str(uid) + '/'
	if os.path.exists(UNIQUE_RUNDIR):
		print (UNIQUE_RUNDIR + 'Run directory exists, exiting...')
		sys.exit()
	else:
		os.makedirs(UNIQUE_RUNDIR)


	## Create submit script
	script_name = UNIQUE_RUNDIR + 'submit_' + str(uid) + '.sh'
	print ('generating script: ' + script_name)
	file = open(script_name,"w")
	
	file.write('#!/bin/bash\n\n') 
	
	unique_jid = ROOT_PANTHEON_WORKFLOW_JID + '_' + str(uid) 
	line = '#BSUB -J ' +  str(unique_jid) + '\n'
	file.write(line)
	line = '#BSUB -nnodes ' +  str(pid) + '\n'
	file.write(line)
	line = '#BSUB -P ' +  'csc420' + '\n'
	file.write(line)
	line = '#BSUB -W ' +  '00:03' + '\n\n'
	file.write(line)

	line = 'module load gcc/6.4.0' + '\n'
	file.write(line)
	line = 'module load cmake/3.14.2' + '\n'
	file.write(line)
	line = 'module load hdf5/1.8.18' + '\n\n'
	file.write(line)

	line = 'jsrun -n ' + str(pid) + ' ' + UNIQUE_RUNDIR + exec_name + ' inputs'
	print ('Job submit: ' + line)
	file.write(line)
	
	file.close()

	## Copy support APP support files
	cp_command = 'cp -rf ' + ROOT_PANTHEON_WORKFLOW_DIR + '/nyx/Nyx/Exec/LyA/* ' + UNIQUE_RUNDIR
	os.system(cp_command)

	## Copy input files
	cp_command = 'cp inputs/ascent/* ' + UNIQUE_RUNDIR
	os.system(cp_command)
	
	## Replace phi and theta values inplace in the copied actions file
	filereplace(UNIQUE_RUNDIR+'ascent_actions.json','''"phi": "4"''', '"phi":' + str(f'"{phi_val}"'))
	filereplace(UNIQUE_RUNDIR+'ascent_actions.json','''"theta": "4"''', '"theta":' + str(f'"{theta_val}"'))
	
	## Limit number of steps to run in Nyx input file
	filereplace(UNIQUE_RUNDIR+'inputs',"max_step = 10000000","max_step = 3")


	## Submit the JOB
	submit_command = 'bsub ' + script_name
	os.system(submit_command)

	

