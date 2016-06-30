# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function show_dots {
    while IFS= read -r line; do
        printf .
    done
    echo
}

function build_libs {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    local start_dir=$PWD
    if [ -n "$IS_OSX" ]; then
        brew install cmake
    else
        alias cmake=cmake28
        cd /
        build_bzip2
    fi
    curl -LO https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz
    echo Done downloading
    tar zxf boost_1_61_0.tar.gz
    echo Done unpacking
    cd boost_1_61_0
    ./bootstrap.sh
    # Reduce verbosity by showing dots for continuing stdout lines
    ./b2 --prefix=/usr/local | show_dots
    cd $start_dir
}

function build_wheel {
    build_libs $PLAT
    build_pip_wheel $@
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    python -c "import dlib"
}
