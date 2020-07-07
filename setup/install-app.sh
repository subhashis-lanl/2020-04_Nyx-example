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
git checkout 0dbb88eb067149d719fa1eaf2f46d0b38385b466

git clone --branch ascent https://github.com/AMReX-Astro/Nyx.git
git checkout bd7fe8a9f553b9588ea1f90b37705add05d9fec2

pushd Nyx/Exec/LyA

# static build on summit
#ASCENT_INSTALL_DIR=/gpfs/alpine/world-shared/csc340/software/ascent/current/summit/openmp/gnu/ascent-install
#ASCENT_INSTALL_DIR=/gpfs/alpine/csc340/world-shared/software/ascent/0.5.2-pre/summit/cuda/gnu/ascent-install
ASCENT_INSTALL_DIR=/gpfs/alpine/proj-shared/csc340/larsen/ascent_5_5_20_openmp/uberenv_libs/ascent-install

make -j 4 \
        AMREX_HOME=${PANTHEON_WORKFLOW_DIR}/$PACKAGEDIR/amrex \
        USE_ASCENT_INSITU=TRUE \
        USE_MPI=TRUE \
        USE_OMP=FALSE \
        ASCENT_HOME=$ASCENT_INSTALL_DIR
popd
popd
