# To build this, run the following command
# build -f Dockerfile -t wrhuang/default:dev .

#==> HOROVOD OFFICIAL DOCKERFILE with mxnet and examples removed
FROM nvidia/cuda:10.0-devel-ubuntu18.04

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ENV TENSORFLOW_VERSION=1.14.0
ENV PYTORCH_VERSION=1.2.0
ENV TORCHVISION_VERSION=0.4.0
ENV CUDNN_VERSION=7.6.0.64-1+cuda10.0
ENV NCCL_VERSION=2.4.7-1+cuda10.0

# Python 2.7 or 3.6 is supported by Ubuntu Bionic out of the box
ARG python=3.6
ENV PYTHON_VERSION=${python}

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-4.8 \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libcudnn7=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION} \
        libnccl-dev=${NCCL_VERSION} \
        libjpeg-dev \
        libpng-dev \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers

RUN if [[ "${PYTHON_VERSION}" == "3.6" ]]; then \
        apt-get install -y python${PYTHON_VERSION}-distutils; \
    fi
RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install TensorFlow, Keras, PyTorch
RUN pip install future typing
RUN pip install numpy \
        tensorflow-gpu==${TENSORFLOW_VERSION} \
        keras \
        h5py
RUN pip install https://download.pytorch.org/whl/cu100/torch-${PYTORCH_VERSION}-$(python -c "import wheel.pep425tags as w; print('-'.join(w.get_supported()[0][:-1]))")-manylinux1_x86_64.whl \
        https://download.pytorch.org/whl/cu100/torchvision-${TORCHVISION_VERSION}-$(python -c "import wheel.pep425tags as w; print('-'.join(w.get_supported()[0][:-1]))")-manylinux1_x86_64.whl

# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-4.0.0.tar.gz && \
    tar zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 pip install --no-cache-dir horovod && \
    ldconfig

# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# ==> RONNY CUSTOM
## Force rebuild beyond this point (dont cache)
## Run this command when building or just change the value here
## docker build -t wrhuang/default --build-arg CACHEBUST=$(date +%s) .
ARG CACHEBUST=1

# permit root login via ssh
RUN sed -i -e 's/prohibit-password/yes/g' /etc/ssh/sshd_config
RUN sed -i -e 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
RUN service ssh restart
RUN echo 'root:password' | chpasswd

# useful apt packages
RUN apt install screen
RUN apt-get install htop
# cache github passwords so dont need to login everytime
RUN git config --global credential.helper cache

# pull scripts from github bin and copy .bashrc, .vimrc, and .inputrc
RUN git clone https://github.com/wronnyhuang/bin /root/bin
RUN cp /root/bin/.bashrc /root/
RUN cp /root/bin/.vimrc /root/bin/.inputrc /root/

# setup scripts for ssh tunneling, aka copy ngrok and nssh into home
RUN cp /root/bin/nsshguest /root/bin/nssh /root/bin/ngrok /root/

# install vim plugins
RUN sh /root/bin/install_vundle.sh
RUN sh /root/bin/install_commentary_instructions.sh

# remove bin folder
RUN rm -rf /root/bin

# ==> USEFUL PYTHON PACKAGES
RUN python -m pip install -U pip && \
    python -m pip install -U matplotlib
RUN pip install mpi4py
RUN pip install -U scikit-learn
RUN pip install pandas
RUN pip install comet_ml
RUN pip install cometml_api
RUN pip install sigopt
RUN pip install tensorflow-hub

WORKDIR "/root"
CMD [ "/bin/bash" ]
