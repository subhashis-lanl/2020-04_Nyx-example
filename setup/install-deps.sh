#!/bin/bash -l

# adding comment

source ./env.sh

echo "PTN: Establishing Pantheon workflow directory:"
echo $PANTHEON_WORKFLOW_DIR

PANTHEON_SOURCE_ROOT=$PWD

# build serial or parallel
    # serial
# BUILD_FLAGS=""
    # parallel
BUILD_FLAGS="-j"

# these settings allow you to control what gets built ... 
BUILD_CLEAN=true
BUILD_WORKFLOW=true
BUILD_CONDUIT=false
BUILD_VTKM=false
BUILD_VTKH=false
BUILD_ASCENT=false
BUILD_APP=true
BUILD_CINEMA=false

# other variables
CMAKE_C_COMPILER=/sw/summit/gcc/6.4.0/bin/gcc
CMAKE_CXX_COMPILER=/sw/summit/gcc/6.4.0/bin/g++
HDF5_DIR=/autofs/nccs-svm1_sw/summit/.swci/1-compute/opt/spack/20180914/linux-rhel7-ppc64le/xl-16.1.1-3/hdf5-1.8.18-pvculx6ftpk4en4ktofhcu2gvye66a6b

# install locations
CONDUIT_INSTALL_DIR=$PANTHEON_WORKFLOW_DIR/conduit/install
VTKM_INSTALL_DIR=$PANTHEON_WORKFLOW_DIR/vtk-m/install
VTKH_INSTALL_DIR=$PANTHEON_WORKFLOW_DIR/vtk-h/install
ASCENT_INSTALL_DIR=$PANTHEON_WORKFLOW_DIR/ascent/install

# commits
CONDUIT_COMMIT=3ccfa03970a144614bb9761c5e6804f6f52695fd
VTKM_COMMIT=c49390f2537c5ba8cf25bd39aa5c212d6eafcf61
VTKH_COMMIT=5d19faed72554b1a8f88a362d9e18dbfaf4228dc
ASCENT_COMMIT=39201d03622934e4f29470191081da90ff9e8205

# ---------------------------------------------------------------------------
#
# Build things, based on flags set above
#
# ---------------------------------------------------------------------------

# if a clean build, remove everything
if $BUILD_CLEAN; then
    echo "--------------------------------------------------"
    echo "PTN: clean build ..."
    echo "--------------------------------------------------"
    if [ -d $PANTHEON_WORKFLOW_DIR ]; then
        rm -rf $PANTHEON_WORKFLOW_DIR
    fi
    if [ ! -d $PANTHEONPATH ]; then
        mkdir $PANTHEONPATH
    fi
    mkdir $PANTHEON_WORKFLOW_DIR
    mkdir $PANTHEON_DATA_DIR
fi

# build the application and parts as needed
if $BUILD_WORKFLOW; then
    pushd $PANTHEON_WORKFLOW_DIR
    pwd

    echo "--------------------------------------------------"
    echo "PTN: Making App ..."
    echo "--------------------------------------------------"
    module load gcc/6.4.0
    module load cuda/10.1.168 
    module load cmake/3.14.2
    module load hdf5/1.8.18

    PACKAGE="CONDUIT"
    if $BUILD_CONDUIT; then
        echo "--------------------------------------------------"
        echo "PTN: building $PACKAGE"
        echo "--------------------------------------------------"
        git clone --recursive https://github.com/LLNL/conduit.git
        pushd conduit
        git checkout $CONDUIT_COMMIT
        git submodule init
        git submodule update

        mkdir build
        mkdir install
        pushd build

        echo "PTN: running cmake ..."
        cmake   -DBUILD_SHARED_LIBS=ON \
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
                -DCMAKE_BUILD_TYPE=Release \
                -DBUILD_SHARED_LIBS=OFF \
                -DENABLE_FORTRAN=ON ../src

        cmake   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
                -DCMAKE_BUILD_TYPE=Release \
                -DBUILD_SHARED_LIBS=OFF \
                -DENABLE_MPI=ON \
                -DENABLE_OPENMP=OFF \
                -DENABLE_PYTHON=OFF \
                -DCMAKE_INSTALL_PREFIX=${CONDUIT_INSTALL_DIR} \
                -DHDF5_DIR=${HDF5_DIR} \
                ../src

        make $BUILD_FLAGS
        make install

        popd
        popd
    fi

    PACKAGE="VTKM"
    if $BUILD_VTKM; then
        echo "--------------------------------------------------"
        echo "PTN: building $PACKAGE"
        echo "--------------------------------------------------"

        git clone --recursive  https://gitlab.kitware.com/vtk/vtk-m.git
        pushd vtk-m
        git checkout $VTKM_COMMIT

        mkdir build
        mkdir install
        pushd build

        cmake   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
                -DCMAKE_BUILD_TYPE=Release \
                -DVTKm_USE_64BIT_IDS=OFF \
                -DVTKm_USE_DOUBLE_PRECISION=ON \
                -DVTKm_ENABLE_OPENMP=OFF \
                -DVTKm_ENABLE_MPI=OFF \
                -DBUILD_SHARED_LIBS=OFF \
                -DVTKm_ENABLE_CUDA=ON \
                -DCMAKE_INSTALL_PREFIX=${VTKM_INSTALL_DIR} \

        cmake   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
                -DCMAKE_BUILD_TYPE=Release \
                -DVTKm_USE_64BIT_IDS=OFF \
                -DVTKm_USE_DOUBLE_PRECISION=ON \
                -DVTKm_ENABLE_OPENMP=OFF \
                -DVTKm_ENABLE_MPI=OFF \
                -DVTKm_ENABLE_CUDA=ON \
                -DBUILD_SHARED_LIBS=OFF  \
                -DVTKm_CUDA_Architecture=volta \
                -DVTKm_ENABLE_TESTING=OFF \
                -DCMAKE_INSTALL_PREFIX=${VTKM_INSTALL_DIR} \

        make $BUILD_FLAGS
        make install

        popd
        popd

    fi

    PACKAGE="VTKH"
    if $BUILD_VTKH; then
        echo "--------------------------------------------------"
        echo "PTN: building $PACKAGE"
        echo "--------------------------------------------------"

        git clone --recursive https://github.com/Alpine-DAV/vtk-h.git
        pushd vtk-h
        git checkout $VTKH_COMMIT

        mkdir build
        mkdir install
        pushd build

        cmake   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
                -DVTKM_DIR=${VTKM_INSTALL_DIR} \
                -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_INSTALL_PREFIX=${VTKH_INSTALL_DIR} \
                -DENABLE_OPENMP=OFF \
                -DENABLE_CUDA=ON \
                -DVTKm_CUDA_Architecture=volta \
                -DENABLE_MPI=ON \
                -DBUILD_SHARED_LIBS=OFF ../src

        make $BUILD_FLAGS 
        make install

        popd
        popd
    fi

    PACKAGE="ASCENT"
    if $BUILD_ASCENT; then
        echo "--------------------------------------------------"
        echo "PTN: building $PACKAGE"
        echo "--------------------------------------------------"

        git clone --recursive https://github.com/Alpine-DAV/ascent.git
        pushd ascent
        git checkout $ASCENT_COMMIT

        mkdir build
        mkdir install
        pushd build

        for i in 1 2
        do
            echo "PTN: ASCENT CMake $i"
            cmake   -DBUILD_SHARED_LIBS=ON \
                    -DENABLE_OPENMP=OFF \
                    -DENABLE_CUDA=ON \
                    -DENABLE_MPI=ON \
                    -DCONDUIT_DIR=${CONDUIT_INSTALL_DIR} \
                    -DVTKM_DIR=${VTKM_INSTALL_DIR} \
                    -DVTKH_DIR=${VTKH_INSTALL_DIR} \
                    -DHDF5_DIR=${HDF5_DIR} \
                    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
                    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
                    -DCMAKE_BUILD_TYPE=Release \
                    -DENABLE_PYTHON=OFF \
                    -DCMAKE_INSTALL_PREFIX=${ASCENT_INSTALL_DIR} \
                    -DBUILD_SHARED_LIBS=OFF \
                    ../src
        done

        make $BUILD_FLAGS
        make install

        popd
        popd
    fi

    if $BUILD_APP; then
        source $PANTHEON_SOURCE_ROOT/setup/install-app.sh
    fi

    popd
fi

if $BUILD_CINEMA; then
    echo "--------------------------------------------------"
    echo "PTN: Cinema installation: BEGIN"
    echo "--------------------------------------------------"
    module load python/3.6.6-anaconda3-5.3.0
    pushd submodules/cinema_lib
    pip install --user .
    echo "--------------------------------------------------"
    echo "PTN: Cinema installation: SUCCESS"
    echo "--------------------------------------------------"
fi
