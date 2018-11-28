# ===> TENSORFLOW DOCKERFILE

FROM nvidia/cuda:9.0-base-ubuntu16.04

LABEL maintainer="Craig Citro <craigcitro@google.com>"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-9-0 \
        cuda-cufft-9-0 \
        cuda-curand-9-0 \
        cuda-cusolver-9-0 \
        cuda-cusparse-9-0 \
        curl \
        libcudnn7=7.2.1.38-1+cuda9.0 \
        libnccl2=2.2.13-1+cuda9.0 \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 && \
        apt-get update && \
        apt-get install libnvinfer4=4.1.2-1+cuda9.0

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        Pillow \
        h5py \
        ipykernel \
        jupyter \
        keras_applications \
        keras_preprocessing \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn \
        && \
    python -m ipykernel.kernelspec

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

CMD ["/run_jupyter.sh", "--allow-root"]

# ===> ANACONDA3 DOCKERFILE

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
#    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
#    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
#    dpkg -i tini.deb && \
#    rm tini.deb && \
    apt-get clean

# ===> install conda tensorflow-gpu, takes a long time

RUN conda install tensorflow-gpu=1.9

# ===> Ronny's custom commands

# apt-get packages
RUN apt-get install -y openssh-server && apt-get clean
RUN apt-get install -y vim && apt-get clean
#RUN apt-get install -y xorg && apt-get clean
#RUN apt-get install -y openbox && apt-get clean

# permit root login via ssh
RUN sed -i -e 's/prohibit-password/yes/g' /etc/ssh/sshd_config
RUN service ssh restart
RUN echo 'root:password' | chpasswd

# ===> Force rebuild beyond this point (dont cache)
ARG CACHEBUST=1 # pass this as argument to build command

# useful python packages
RUN pip install opencv-python
RUN pip install editdistance
RUN pip install comet_ml
RUN pip install cometml_api
RUN pip install sigopt

# pull scripts from github bin and copy .bashrc, .vimrc, and .inputrc
RUN git clone https://github.com/wronnyhuang/bin /root/bin # clone my bin folder for useful scripts
RUN cp /root/bin/.bashrc /root/ # replace bashrc file to have colors and print welcome message
RUN cp /root/bin/.vimrc /root/bin/.inputrc /root/ # copy vimrc and inputrc configs into home

# install vim plugins
RUN sh /root/bin/install_vundle.sh
RUN sh /root/bin/install_commentary_instructions.sh

# setup scripts for ssh tunneling, aka copy ngrok and nssh into home
RUN cp /root/bin/nssh /root/bin/ngrok /root/ # permanently store ssh tunneling setup scripts in the image

# setup dropbox uploader
RUN echo as1rfaem15QAAAAAAABK5bbRELhSf4rZaOEJuss5rFKscFtYvPvtMbvVNLFC9G2O > token.txt
RUN sh /root/bin/dbx

# remove bin folder
RUN rm -rf /root/bin # remove bin folder (will be mapped later)

WORKDIR "/root"
CMD [ "/bin/bash" ]

