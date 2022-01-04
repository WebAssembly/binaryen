#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SYSTEM=$(uname)
if [ "${SYSTEM}" = "Linux" ]; then
    export LD_LIBRARY_PATH=${SCRIPT_DIR}/../lib
elif [ "${SYSTEM}" = "Darwin" ]; then
    export DYLD_LIBRARY_PATH=${SCRIPT_DIR}/../lib
else
    echo "Unsupported system ${SYSTEM}"
    exit 1
fi
${SCRIPT_DIR}/wasi-stub $@