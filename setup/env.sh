# Choose directory where "opt" will be created
# "opt" is the home for all source and install directories
# for all dependencies.

# read ids from pantheon file
export PANTHEON_WORKFLOW_ID=`awk '/pantheonid/{print $NF}' pantheon/pantheon.yml`
# create the job id - a lower case version of the workflow id
export PANTHEON_WORKFLOW_JID=${PANTHEON_WORKFLOW_ID,,}

# this instance's working directory
export PANTHEON_BASE_PATH=$MEMBERWORK/csc340
export PANTHEONPATH=$PANTHEON_BASE_PATH/pantheon
export PANTHEON_WORKFLOW_DIR=$PANTHEONPATH/$PANTHEON_WORKFLOW_ID

# run directory
PANTHEON_RUN_DIR=$PANTHEON_WORKFLOW_DIR/results

# data directory
export PANTHEON_DATA_DIR=$PANTHEON_WORKFLOW_DIR/data

# cinema
export CINEMAPATH=$(pwd)/submodules/cinema_lib/.local/summit/anaconda3/5.3.0/3.6/bin/cinema
export CINEMA_PYTHONPATH=$(pwd)/submodules/cinema_lib/.local/summit/anaconda3/5.3.0/3.6/lib/python3.6/site-packages
