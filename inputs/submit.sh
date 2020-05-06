#!/bin/bash

#BSUB -J <pantheon_workflow_jid> 
#BSUB -nnodes 8
#BSUB -P AST160
#BSUB -W 00:05

module load gcc/6.4.0
module load cuda/10.1.168 
module load cmake/3.14.2
module load hdf5/1.8.18

jsrun -n 16 -g 1  <pantheon_run_dir>/Nyx3d.gnu.PROF.MPI.ex inputs max_step=10
