# build and install the application

PACKAGE="NYX"
# make a lower case version of the package 
PACKAGEDIR=${PACKAGE,,}

echo "--------------------------------------------------"
echo "PTN: building $PACKAGE"
echo "--------------------------------------------------"

mkdir $PACKAGEDIR 
pushd $PACKAGEDIR

git clone --branch development https://github.com/AMReX-Codes/amrex.git
git clone --branch ascent https://github.com/AMReX-Astro/Nyx.git

pushd Nyx/Exec/LyA

make -j 4 \
        AMREX_HOME=${PANTHEON_WORKFLOW_DIR}/$PACKAGEDIR/amrex \
        USE_GPU=TRUE \
        USE_ASCENT_INSITU=TRUE \
        ASCENT_DIR=$ASCENT_INSTALL_DIR \
        CONDUIT_DIR=$CONDUIT_INSTALL_DIR \
        VTKH_DIR=$VTKH_INSTALL_DIR \
        VTKM_DIR=$VTKM_INSTALL_DIR

popd
popd
