#!/bin/bash

#BSUB -J <pantheon_workflow_jid> 
#BSUB -nnodes 6
#BSUB -P CSC340
#BSUB -W 00:10

module load gcc/6.4.0
module load cuda/10.1.168
module load cmake/3.14.2
module load hdf5/1.8.18

jsrun -n 6 -g 1 <pantheon_workflow_dir>/sw4/optimize/sw4 hayward-att-h100.in
