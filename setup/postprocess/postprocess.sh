#!/bin/bash 

source env.sh

if [ ! -d $PANTHEON_DATA_DIR ]; then
    mkdir $PANTHEON_DATA_DIR
fi
CDB_BASE=$PANTHEON_RUN_DIR
CDB_DIR=$CDB_BASE/cinema_databases
CDB=$CDB_DIR/WarpX_example

RUN_ANALYSIS=true
if $RUN_ANALYSIS; then
    echo 'This workflow needs to start from its own base directory'
    pushd submodules/cinema_workflows/2019-09_ASCENT
    ./run $CDB $CDB
    echo 'Move the viewer to the data'
    mkdir $CDB_DIR/cinema
    cp -rf cinema/* $CDB_DIR/cinema
    cp -rf explore.html $CDB_DIR 
    # rewrite the databases file
    cp ../../../data/databases.json $CDB_DIR/cinema/explorer/1.9
    popd
fi

PACKAGE=true
if $PACKAGE; then
    echo 'Package the viewer+db tarball for xfer and validation'
    pushd $CDB_BASE
    tar -cvJf ${PANTHEON_DATA_DIR}/cinema_viewer.tar.xz cinema_databases/
    echo ===========================================================
    echo Cinema database tarball created:
    echo  ${PANTHEON_DATA_DIR}/cinema_viewer.tar.xz
    echo
    echo Please transfer this to a computer with Firefox, unpack
    echo the tarball, and open explore.html.
    echo 
    echo ===========================================================
fi
