# Pantheon environment file

# summit environment
SUMMIT_ALLOCATION=aaa000

# read values from pantheon file
export PANTHEON_WORKFLOW_ID=`awk '/pantheonid/{print $NF}' pantheon/pantheon.yml`
    # create the job id - a lower case version of the workflow id
export PANTHEON_WORKFLOW_JID=`echo "$PANTHEON_WORKFLOW_ID" | awk '{print tolower($0)}'`
export PANTHEON_APP=`awk '/workflow_app/{print $NF}' pantheon/pantheon.yml`

# this instance's working directory
export PANTHEON_BASE_PATH=$MEMBERWORK/$SUMMIT_ALLOCATION
export PANTHEONPATH=$PANTHEON_BASE_PATH/pantheon
export PANTHEON_WORKFLOW_DIR=$PANTHEONPATH/$PANTHEON_WORKFLOW_ID
export PANTHEON_RUN_DIR=$PANTHEON_WORKFLOW_DIR/results
export PANTHEON_DATA_DIR=$PANTHEON_WORKFLOW_DIR/data

# cinema
export CINEMAPATH=$(pwd)/submodules/cinema_lib/.local/summit/anaconda3/5.3.0/3.6/bin/cinema
export CINEMA_PYTHONPATH=$(pwd)/submodules/cinema_lib/.local/summit/anaconda3/5.3.0/3.6/lib/python3.6/site-packages

# print
echo ----------------------------------------------------------------------
echo Pantheon Environment
echo ----------------------------------------------------------------------
echo PANTHEONPATH.........: $PANTHEONPATH
echo PANTHEON_WORKFLOW_DIR: $PANTHEON_WORKFLOW_DIR
echo PANTHEON_RUN_DIR.....: $PANTHEON_RUN_DIR
echo PANTHEON_DATA_DIR....: $PANTHEON_DATA_DIR
echo PANTHEON_WORKFLOW_ID.: $PANTHEON_WORKFLOW_ID
echo PANTHEON_WORKFLOW_JID: $PANTHEON_WORKFLOW_JID
echo PANTHEON_APP.........: $PANTHEON_APP
echo ----------------------------------------------------------------------
