#!/bin/bash

# source /opt/rh/devtoolset-7/enable
# -DCMAKE_C_COMPILER=`which gcc`
cmake . -DBUILD_TESTS=OFF -DENABLE_WERROR=OFF
make
