# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function dot_per_line {
    # http://unix.stackexchange.com/questions/117501/in-bash-script-how-to-capture-stdout-line-by-line
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
        ln -sf $(which cmake28) /usr/bin/cmake
    fi
    curl -LO https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz
    echo Done downloading
    tar zxf boost_1_61_0.tar.gz
    echo Done unpacking
    cd boost_1_61_0
    ./bootstrap.sh --with-python=python --with-libraries=python --prefix=/usr/local
    # Reduce verbosity by showing dots for continuing stdout lines
    ./b2
    ./b2 install
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
