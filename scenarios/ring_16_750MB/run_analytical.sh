#!/bin/bash
set -e

## ******************************************************************************
## This source code is licensed under the MIT license found in the
## LICENSE file in the root directory of this source tree.
##
## Copyright (c) 2024 Georgia Institute of Technology
## ******************************************************************************

# find the absolute path to this script
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo ${SCRIPT_DIR}
PROJECT_DIR="${SCRIPT_DIR:?}/../.."

# paths
ASTRA_SIM="${PROJECT_DIR:?}/build/astra_analytical/build/bin/AstraSim_Analytical_Congestion_Aware"
WORKLOAD="${SCRIPT_DIR:?}/workload/all_reduce"
SYSTEM="${SCRIPT_DIR:?}/system.json"
NETWORK="${SCRIPT_DIR:?}/analytical_network.yml"
REMOTE_MEMORY="${PROJECT_DIR:?}/examples/remote_memory/analytical/no_memory_expansion.json"

# start
echo "[ASTRA-sim] Compiling ASTRA-sim with the Analytical Network Backend..."
echo ""

# Compile
"${PROJECT_DIR:?}"/build/astra_analytical/build.sh

echo ""
echo "[ASTRA-sim] Compilation finished."
echo "[ASTRA-sim] Running ASTRA-sim Example with Analytical Network Backend..."
echo ""

# run ASTRA-sim
"${ASTRA_SIM:?}" \
    --workload-configuration="${WORKLOAD}" \
    --system-configuration="${SYSTEM:?}" \
    --remote-memory-configuration="${REMOTE_MEMORY:?}" \
    --network-configuration="${NETWORK:?}"

# finalize
echo ""
echo "[ASTRA-sim] Finished the execution."
