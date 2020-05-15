# build and install the application

PACKAGE="NYX"
# make a lower case version of the package 
PACKAGEDIR=`echo "$PACKAGE" | awk '{print tolower($0)}'`

echo "--------------------------------------------------"
echo "PTN: building $PACKAGE"
echo "--------------------------------------------------"

# commits
NYX_COMMIT=bd7fe8a9f553b9588ea1f90b37705add05d9fec2
AMREX_COMMIT=a595fc350b7c610799233b46f0f7aa0347d57404

mkdir $PACKAGEDIR 
pushd $PACKAGEDIR

# Clone AMReX repository
git clone --branch development https://github.com/AMReX-Codes/amrex.git
pushd amrex
git checkout $AMREX_COMMIT
popd

# Clone ASCENT repository
git clone --branch ascent https://github.com/AMReX-Astro/Nyx.git
pushd Nyx
git checkout $NYX_COMMIT
popd


pushd Nyx/Exec/LyA

# static build on summit
ASCENT_VERSION=0.5.2-pre
#ASCENT_INSTALL_DIR=/gpfs/alpine/world-shared/csc340/software/ascent/$ASCENT_VERSION/summit/openmp/gnu/ascent-install
ASCENT_INSTALL_DIR=/gpfs/alpine/proj-shared/csc340/larsen/ascent_5_5_20_openmp/uberenv_libs/ascent-install


make -j 36 \
        AMREX_HOME=$PANTHEON_WORKFLOW_DIR/$PACKAGEDIR/amrex \
        USE_ASCENT_INSITU=TRUE \
        USE_MPI=TRUE \
        USE_OMP=FALSE \
        ASCENT_HOME=$ASCENT_INSTALL_DIR
popd
popd
