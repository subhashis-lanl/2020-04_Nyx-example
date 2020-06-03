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
num_procs = [4]
phi = [4]
theta = [4]
image_size = [256]

exec_name = 'Nyx3d.gnu.PROF.MPI.OMP.ex'

## Read PANTHEON specific environment variables
ROOT_PANTHEONPATH =os.getenv("PANTHEONPATH")
ROOT_PANTHEON_WORKFLOW_DIR = os.getenv("PANTHEON_WORKFLOW_DIR")
ROOT_PANTHEON_RUN_DIR = os.getenv("PANTHEON_RUN_DIR")
ROOT_PANTHEON_DATA_DIR = os.getenv("PANTHEON_DATA_DIR")
ROOT_PANTHEON_WORKFLOW_ID = os.getenv("PANTHEON_WORKFLOW_ID")
ROOT_PANTHEON_WORKFLOW_JID = os.getenv("PANTHEON_WORKFLOW_JID") 

#######################################################################
#Create job scripts with different parameter configurations and submit
for param in itertools.product(num_procs,phi,theta,image_size):
	
	##uid is a unique id will be used to name the scripts.
	pid = param[0]
	phi_val = param[1]
	theta_val = param[2]
	isize = param[3]
	
	## uid is a unique identifier used to create folders and files	
	uid = 'proc' + str(pid) + '_phi' + str(phi_val) + '_theta' + str(theta_val) + '_isize' + str(isize)
	
	## generate unique run directories
	UNIQUE_RUNDIR = ROOT_PANTHEON_RUN_DIR + '_' + str(uid) + '/'
	if os.path.exists(UNIQUE_RUNDIR):
		print (UNIQUE_RUNDIR + 'Run directory exists, exiting...')
		sys.exit()
	else:
		os.makedirs(UNIQUE_RUNDIR)

	## Create submit script
	script_name = UNIQUE_RUNDIR + 'submit_' + str(uid) + '.sh'
	file = open(script_name,"w")
	
	file.write('#!/bin/bash\n\n') 
	
	unique_jid = ROOT_PANTHEON_WORKFLOW_JID + '_' + str(uid) 
	line = '#BSUB -J ' +  str(unique_jid) + '\n'
	file.write(line)
	line = '#BSUB -nnodes ' +  str(pid) + '\n'
	file.write(line)
	line = '#BSUB -P ' +  'csc420' + '\n'
	file.write(line)
	line = '#BSUB -W ' +  '00:02' + '\n\n'
	file.write(line)

	line = 'module load gcc/6.4.0' + '\n'
	file.write(line)
	line = 'module load cmake/3.14.2' + '\n'
	file.write(line)
	line = 'module load hdf5/1.8.18' + '\n\n'
	file.write(line)

	line = 'jsrun -n ' + str(pid) + ' ' + UNIQUE_RUNDIR + exec_name + ' inputs'
	file.write(line)
	
	file.close()

	## Copy support APP support files
	cp_command = 'cp -rf ' + ROOT_PANTHEON_WORKFLOW_DIR + '/nyx/Nyx/Exec/LyA/* ' + UNIQUE_RUNDIR
	#print (cp_command)
	os.system(cp_command)
	## remove any existing ascent actions file
	os.system('rm ' + UNIQUE_RUNDIR + 'ascent_actions*')

	## Copy input files
	cp_command = 'cp inputs/ascent/* ' + UNIQUE_RUNDIR
	os.system(cp_command)
	
	## Replace phi and theta values inplace in the copied actions file
	filereplace(UNIQUE_RUNDIR+'ascent_actions.yaml','phi: 4', 'phi: ' + str(phi_val))
	filereplace(UNIQUE_RUNDIR+'ascent_actions.yaml','theta: 4', 'theta: ' + str(theta_val))
	filereplace(UNIQUE_RUNDIR+'ascent_actions.yaml','image_width: 512', 'image_width: ' + str(isize))
	filereplace(UNIQUE_RUNDIR+'ascent_actions.yaml','image_height: 512', 'image_height: ' + str(isize))
	
	## Limit number of steps to run in Nyx input file
	#filereplace(UNIQUE_RUNDIR+'inputs',"max_step = 10000000","max_step = 3")
	## Stop dumping plt files
	filereplace(UNIQUE_RUNDIR+'inputs',"amr.plot_int        = 1","amr.plot_int = -1")
	## Stop dumping checkpoint files
	filereplace(UNIQUE_RUNDIR+'inputs',"amr.check_int         = 100","amr.check_int = -1")
	## Use a specific checkpoint file
	filereplace(UNIQUE_RUNDIR+'inputs',"#amr.restart = chk00100","amr.restart = /ccs/home/dutta/Nyx_chekpoints/chk00350")
	
	## Go the submit directory and submit the JOB and come back to the working directory
	current_dir = os.getcwd() ## save the current working dir
	os.chdir(UNIQUE_RUNDIR) ## Go to submit dir		
	submit_command = 'bsub ' + 'submit_' + str(uid) + '.sh'
	os.system(submit_command) ## submit the actual job
	os.chdir(current_dir) # come back to working dir


