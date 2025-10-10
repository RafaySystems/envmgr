#!/bin/bash
#SBATCH --job-name=test_slinky_image
#SBATCH --output=/mnt/data/slinky_test_output.txt
#SBATCH --error=/mnt/data/slinky_test_output.txt
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --partition=slinky

set -e

echo "=============================================================================="
echo "===== Testing Slinky Compute Image ====="
echo "=============================================================================="
echo "Job started on $(hostname) at $(date)"
echo ""

print_section() {
  echo ""
  echo "------------------------------------------------------------------------------"
  echo "=== $1 ==="
  echo "------------------------------------------------------------------------------"
  echo ""
}

# ------------------------------------------------------------------------------
# NVIDIA HPC SDK
# ------------------------------------------------------------------------------
print_section "NVIDIA HPC SDK"
if [ -d /opt/nvidia/hpc_sdk ]; then
    export NVHPC_HOME="/opt/nvidia/hpc_sdk/Linux_x86_64/25.9"
    export PATH="$NVHPC_HOME/compilers/bin:$PATH"
    which nvc && nvc --version || echo "nvc not found"
    which nvc++ && nvc++ --version || echo "nvc++ not found"
    which nvfortran && nvfortran --version || echo "nvfortran not found"
else
    echo "NVIDIA HPC SDK not found at /opt/nvidia/hpc_sdk"
fi

# ------------------------------------------------------------------------------
# Python & PyTorch
# ------------------------------------------------------------------------------
print_section "Python & PyTorch"
source /opt/venv/bin/activate || echo "Python venv not found"
python3 -c "import sys, torch; print(f'Python: {sys.version}'); print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA device count: {torch.cuda.device_count()}')" || echo "Python/PyTorch test failed"

# ------------------------------------------------------------------------------
# Lmod Modules
# ------------------------------------------------------------------------------
print_section "Lmod Modules"
source /usr/local/lmod/lmod/init/bash
if [ -z "$MODULEPATH" ]; then
    export MODULEPATH=/usr/local/lmod/lmod/modulefiles
fi
module avail || echo "Lmod modules unavailable"

# ------------------------------------------------------------------------------
# Lua + posix
# ------------------------------------------------------------------------------
print_section "Lua + posix"
lua -e "require('posix'); print('Lua posix loaded')" || echo "Lua posix test failed"

# ------------------------------------------------------------------------------
# HPC-X / OpenMPI
# ------------------------------------------------------------------------------
print_section "HPC-X / OpenMPI"
if [ -d /opt/hpcx ]; then
    export HPCX_HOME="/opt/hpcx"
    source $HPCX_HOME/hpcx-init.sh
    hpcx_load
    which mpirun && mpirun --version || echo "HPC-X mpirun not found"
else
    echo "HPC-X not found at /opt/hpcx"
fi

# ------------------------------------------------------------------------------
# MPI Python Hello World
# ------------------------------------------------------------------------------
print_section "MPI Python Hello World"

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

mpirun -np $SLURM_NTASKS --bind-to none python3 -u <<'EOF'
from mpi4py import MPI
comm = MPI.COMM_WORLD
if comm.rank == 0:
    print("----- MPI Python Hello World -----", flush=True)
print(f"Hello from rank {comm.rank} of {comm.size}", flush=True)
EOF
# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------
print_section "Environment Variables"
echo "NVHPC_HOME=$NVHPC_HOME"
echo "HPCX_HOME=$HPCX_HOME"
echo "CUDA_HOME=$CUDA_HOME"
echo "PATH=$PATH"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

echo ""
echo "=============================================================================="
echo "===== Test Completed at $(date) ====="
echo "=============================================================================="
