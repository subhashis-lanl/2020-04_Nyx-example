# build and install the application

PACKAGE="NYX"
# make a lower case version of the package 
PACKAGEDIR=`echo "$PACKAGE" | awk '{print tolower($0)}'`

echo "--------------------------------------------------"
echo "PTN: building $PACKAGE"
echo "--------------------------------------------------"

mkdir $PACKAGEDIR 
pushd $PACKAGEDIR

git clone --branch development https://github.com/AMReX-Codes/amrex.git
git clone --branch ascent https://github.com/AMReX-Astro/Nyx.git

pushd Nyx/Exec/LyA

# static build on summit
SUMMIT_ALLOCATION=csc340
ASCENT_VERSION=0.5.2-pre
ASCENT_INSTALL_DIR=/gpfs/alpine/world-shared/$SUMMIT_ALLOCATION/software/ascent/$ASCENT_VERSION/summit/openmp/gnu/ascent-install

make -j 4 \
        AMREX_HOME=$PANTHEON_WORKFLOW_DIR/$PACKAGEDIR/amrex \
        USE_ASCENT_INSITU=TRUE \
        USE_MPI=TRUE \
        USE_OMP=FALSE \
        ASCENT_HOME=$ASCENT_INSTALL_DIR
popd
popd
