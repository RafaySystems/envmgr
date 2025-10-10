# ============================
# Base image
# ============================
FROM ghcr.io/slinkyproject/slurmd:25.05.0-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive

# ============================
# Install system dependencies + Python 3.12
# ============================
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl wget git ca-certificates \
    build-essential cmake \
    python3.12 python3.12-venv python3.12-dev python3-pip \
    libnuma1 libnuma-dev \
    libibverbs-dev libtool autoconf pkg-config \
    libglib2.0-0 libsm6 libxext6 libxrender-dev \
    tcl tcl-dev lua5.3 liblua5.3-dev luarocks bc \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# ============================
# Python virtual environment
# ============================
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip setuptools wheel

ENV PATH="/opt/venv/bin:$PATH"

# ============================
# Install mpi4py in venv
# ============================
RUN /opt/venv/bin/pip install mpi4py

# ============================
# CUDA 12.6 runtime libraries
# ============================
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       cuda-cudart-12-6 \
       libcublas-12-6 \
       libcufft-12-6 \
       libcurand-12-6 \
       libcusolver-12-6 \
       libcusparse-12-6 \
       libnccl2 libnccl-dev \
    && rm -rf /var/lib/apt/lists/* cuda-keyring_1.1-1_all.deb

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib:$LD_LIBRARY_PATH
ENV CUDA_HOME=/usr/local/cuda

# ============================
# PyTorch 2.6.0
# ============================
RUN pip install --no-cache-dir torch==2.6.0+cu126 torchvision==0.21.0+cu126 torchaudio==2.6.0+cu126 \
    --index-url https://download.pytorch.org/whl/cu126

# ============================
# Lua posix (required for Lmod)
# ============================
RUN luarocks install luaposix

# ============================
# Lmod 8.7.67
# ============================
RUN wget https://github.com/TACC/Lmod/archive/refs/tags/8.7.67.tar.gz -O /tmp/lmod.tar.gz \
    && tar -xzf /tmp/lmod.tar.gz -C /tmp \
    && cd /tmp/Lmod-8.7.67 && ./configure && make install \
    && rm -rf /tmp/lmod*

ENV PATH=/usr/local/lmod/lmod/libexec:$PATH
ENV MODULEPATH=/usr/local/lmod/lmod/modulefiles:$MODULEPATH

# ============================
# OpenMPI (for HPC-X compatibility)
# ============================
RUN apt-get update && apt-get install -y openmpi-bin libopenmpi-dev \
    && rm -rf /var/lib/apt/lists/*

# ============================
# NVIDIA HPC SDK 25.9
# ============================
RUN wget https://developer.download.nvidia.com/hpc-sdk/25.9/nvhpc_2025_259_Linux_x86_64_cuda_13.0.tar.gz -O /tmp/nvhpc.tar.gz \
    && mkdir -p /opt/nvhpc_installer \
    && tar -xzf /tmp/nvhpc.tar.gz -C /opt/nvhpc_installer --strip-components=1 \
    && rm /tmp/nvhpc.tar.gz \
    && /opt/nvhpc_installer/install --option=auto --install-dir=/opt/nvidia/hpc_sdk \
    && rm -rf /opt/nvhpc_installer

ENV NVHPC_HOME=/opt/nvidia/hpc_sdk/Linux_x86_64/25.9
ENV PATH=$NVHPC_HOME/compilers/bin:$PATH
ENV MANPATH=$NVHPC_HOME/compilers/man:$MANPATH
ENV LD_LIBRARY_PATH=$NVHPC_HOME/compilers/lib:$LD_LIBRARY_PATH

# ============================
# NVIDIA HPC-X v2.24.1 (local tarball)
# ============================
COPY hpcx-v2.24.1-gcc-doca_ofed-ubuntu24.04-cuda13-x86_64.tbz /tmp/
RUN mkdir -p /opt/hpcx && tar -xvf /tmp/hpcx-v2.24.1-gcc-doca_ofed-ubuntu24.04-cuda13-x86_64.tbz -C /opt/hpcx --strip-components=1 \
    && rm /tmp/hpcx-v2.24.1-gcc-doca_ofed-ubuntu24.04-cuda13-x86_64.tbz

ENV HPCX_HOME=/opt/hpcx
ENV PATH=$HPCX_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$HPCX_HOME/lib:$LD_LIBRARY_PATH
ENV MANPATH=$HPCX_HOME/share/man:$MANPATH

# ============================
# Initialize Lmod and venv in bash
# ============================
SHELL ["/bin/bash", "-c"]
RUN echo "source /usr/local/lmod/lmod/init/bash" >> ~/.bashrc
RUN echo "source /opt/venv/bin/activate" >> ~/.bashrc
RUN echo "source $HPCX_HOME/hpcx-init.sh" >> ~/.bashrc

# ============================
# Default command
# ============================
CMD ["bash"]
