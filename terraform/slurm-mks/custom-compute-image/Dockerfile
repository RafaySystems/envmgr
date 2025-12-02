#==========================
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
# Install CUDA toolkit + NCCL from NVIDIA repo
# ============================
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       cuda-toolkit-12-7 \
       libnccl2 libnccl-dev \
       mpich libmpich-dev \
       make gcc g++ \
       wget curl git \
    && rm -rf /var/lib/apt/lists/* cuda-keyring_1.1-1_all.deb

ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64
ENV CUDA_HOME=/usr/local/cuda

# Verify installations
RUN nvcc --version
RUN mpirun --version
RUN nccl-tests_version() { git clone https://github.com/NVIDIA/nccl-tests.git /opt/nccl-tests; }

# ============================
# Build NCCL-tests
# ============================
RUN git clone https://github.com/NVIDIA/nccl-tests.git /opt/nccl-tests && \
    cd /opt/nccl-tests && \
    make MPI=1 MPI_HOME=/usr/lib/x86_64-linux-gnu/mpich CUDA_HOME=/usr/local/cuda NCCL_HOME=/usr -j$(nproc)

ENV PATH=/opt/nccl-tests/build:$PATH


# ============================
# NCCL Configuration
# ============================

# Create /etc/nccl.conf for RoCE v2
RUN echo "NCCL_IB_GID_INDEX=3" > /etc/nccl.conf

# Ensure NCCL uses auto-configuration
ENV NCCL_MIN_NCHANNELS="" \
    NCCL_PROTO="" \
    NCCL_ALGO=""

# ============================
# Install essential editors for SonK
# ============================
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim nano
	
# ============================
# Container Integration
# ============================

# Install Apptainer (Singularity replacement)
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        libseccomp-dev \
        pkg-config \
        squashfs-tools \
        cryptsetup \
        wget \
        git \
        golang-go \
        uuid-dev \
        libgpgme-dev \
        libglib2.0-dev \
        libseccomp-dev \
        runc \
        uidmap \
        make \
        automake \
        autoconf \
        libtool \
        && cd /tmp \
        && wget https://github.com/apptainer/apptainer/releases/download/v1.3.3/apptainer-1.3.3.tar.gz \
        && tar -xzf apptainer-1.3.3.tar.gz \
        && cd apptainer-1.3.3 \
        && ./mconfig --without-suid \
        && make -C builddir \
        && make -C builddir install \
        && rm -rf /tmp/apptainer-1.3.3* \
        && rm -rf /var/lib/apt/lists/*



# Install Docker CLI (not the daemon, just client)
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Set Ubuntu version explicitly for NVIDIA repo
ARG UBUNTU_VERSION=24.04

# Install dependencies, NVIDIA container toolkit repo, Enroot, and Pyxis
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget curl ca-certificates gnupg \
    && wget https://github.com/NVIDIA/enroot/releases/download/v3.5.0/enroot_3.5.0-1_amd64.deb \
    && wget https://github.com/NVIDIA/enroot/releases/download/v3.5.0/enroot+caps_3.5.0-1_amd64.deb \
    && apt install -y ./enroot_3.5.0-1_amd64.deb ./enroot+caps_3.5.0-1_amd64.deb \
    && rm -f enroot_3.5.0-1_amd64.deb enroot+caps_3.5.0-1_amd64.deb \
    && wget https://github.com/NVIDIA/pyxis/releases/download/v0.17.0/pyxis_0.17.0_amd64.deb \
    && apt install -y ./pyxis_0.17.0_amd64.deb \
    && rm -f pyxis_0.17.0_amd64.deb \
    && rm -rf /var/lib/apt/lists/*





# Ensure environment modules (Lmod) is available
RUN apt-get update && apt-get install -y --no-install-recommends \
    lmod \
    && rm -rf /var/lib/apt/lists/*

# ============================
# Initialize Lmod and venv in bash
# ============================
SHELL ["/bin/bash", "-c"]
RUN echo "source /usr/local/lmod/lmod/init/bash" >> ~/.bashrc
RUN echo "source /opt/venv/bin/activate" >> ~/.bashrc

# ============================
# Default command
# ============================
CMD ["bash"]
