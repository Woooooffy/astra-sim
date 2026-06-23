#!/bin/bash
set -e
set -x

SCRIPT_DIR=$(dirname "$(realpath "$0")")
CHAKRA_CONVERTER_DIR="${SCRIPT_DIR}/../../../collectiveapi/chakra_converter"
INPUT_XML="/data/scratch/wangyj05/taccl/taccl/custom_examples/Allgather.n3-Custom-N4-.n1-steps1-tacclsol-improve-1781598576_i1_scRemote1_IBContig.sccl.xml"
# INPUT_XML="/data/commit/graphit/wangyj05/workspace/TE-CCL/star_no_copy.xml"
OUTPUT_FILENAME="${SCRIPT_DIR}/in/all_gather"

mkdir -p "${SCRIPT_DIR}/in"
LOG_DIR="${SCRIPT_DIR}/logs"
mkdir -p "${LOG_DIR}"

export PYTHONPATH=/data/commit/graphit/wangyj05/workspace/astra-sim/extern/graph_frontend/

# SIZE from 3 KiB (3072 bytes) to 3 GiB (3221225472 bytes), doubling each iteration
START_SIZE=$((3 * 1024))
END_SIZE=$((3 * 1024 * 1024 * 1024))

size=${START_SIZE}
while [ "${size}" -le "${END_SIZE}" ]; do
    echo "=========================================="
    echo "Running with coll_size: ${size} bytes"
    echo "=========================================="

    # Generate Chakra traces
    cd "${CHAKRA_CONVERTER_DIR}"
    python3 et_converter.py \
        --input_filename "${INPUT_XML}" \
        --output_filename "${OUTPUT_FILENAME}" \
        --coll_size "${size}" \
        --collective allgather

    # Run ns-3 simulation with generated traces
    bash "${SCRIPT_DIR}/run_ns3.sh" 2>&1 | tee "${LOG_DIR}/old_teccl_${size}.log"

    size=$((size * 2))
done
