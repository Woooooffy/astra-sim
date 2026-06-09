#!/bin/bash
set -e
set -x

# find the absolute path to this script
SCRIPT_DIR=$(dirname "$(realpath "$0")")
ASTRA_SIM_DIR="${SCRIPT_DIR:?}/../.."

# paths
#WORKLOAD="${ASTRA_SIM_DIR:?}/examples/workload/microbenchmarks/all_gather/8npus_1MB/all_gather"
WORKLOAD="${SCRIPT_DIR:?}/msccl_all_gather/all_gather"
#SYSTEM="${SCRIPT_DIR:?}/system.json"
SYSTEM="${SCRIPT_DIR:?}/system.json"

NS3_DIR="${ASTRA_SIM_DIR:?}"/extern/network_backend/ns-3


NETWORK="${NS3_DIR:?}"/scratch/config/config_dgx1.txt
LOGICAL_TOPOLOGY="${SCRIPT_DIR:?}"/logical_topo.json

MEMORY="${ASTRA_SIM_DIR:?}/examples/remote_memory/analytical/no_memory_expansion.json"
COMM_GROUP_CONFIGURATION="empty"

cd "${NS3_DIR}/build/scratch"

echo "Running simulation with WORKLOAD: ${WORKLOAD}"

./ns3.42-AstraSimNetwork-debug \
    --workload-configuration=${WORKLOAD} \
    --system-configuration=${SYSTEM} \
    --network-configuration=${NETWORK} \
    --remote-memory-configuration=${MEMORY} \
    --logical-topology-configuration=${LOGICAL_TOPOLOGY} \
    --comm-group-configuration=${COMM_GROUP_CONFIGURATION}

cd "${SCRIPT_DIR:?}"
