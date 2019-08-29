# ===> TENSORFLOW DOCKERFILE (using only for dependencies with gpu)

ARG UBUNTU_VERSION=16.04

ARG ARCH=
ARG CUDA=10.0
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
ARG CUDNN=7.4.1.5-1

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

LABEL maintainer="W Ronny Huang <wronnyhuang@gmail.com>"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        cuda-cublas-${CUDA/./-} \
        cuda-cufft-${CUDA/./-} \
        cuda-curand-${CUDA/./-} \
        cuda-cusolver-${CUDA/./-} \
        cuda-cusparse-${CUDA/./-} \
        curl \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip

RUN [ ${ARCH} = ppc64le ] || (apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1604-5.0.2-ga-cuda${CUDA} \
        && apt-get update \
        && apt-get install -y --no-install-recommends libnvinfer5=5.0.2-1+cuda${CUDA} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*)

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

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
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean
ENTRYPOINT [ "/usr/bin/tini", "--" ]

## ===> install conda tensorflow-gpu, takes a long time
#RUN conda update -n base conda
#RUN conda install tensorflow-gpu
#
## ===> install conda pytorch
#RUN conda install pytorch torchvision cudatoolkit=10.0 -c pytorch
#
## ===> Ronny's custom commands
#
## apt-get packages
#RUN apt-get install -y openssh-server && apt-get clean
#RUN apt-get install -y vim && apt-get clean
##RUN apt-get install -y xorg && apt-get clean
##RUN apt-get install -y openbox && apt-get clean
#
## permit root login via ssh
#RUN sed -i -e 's/prohibit-password/yes/g' /etc/ssh/sshd_config
#RUN service ssh restart
#RUN echo 'root:password' | chpasswd
#
### install bigfloat [not needed anymore]
##RUN apt-get install libgmp3-dev
##RUN apt-get install libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg
##RUN pip install bigfloat
#
## ===> Force rebuild beyond this point (dont cache)
## Run this command when building or just change the value here
## docker build -t wrhuang/default --build-arg CACHEBUST=$(date +%s) .
##ARG CACHEBUST=6
#
## useful python packages
#RUN pip install opencv-python
#RUN pip install editdistance
#RUN pip install comet_ml
#RUN pip install cometml_api
#RUN pip install sigopt
#RUN pip install tensorflow-hub
#RUN pip install tensorflow-probability
#RUN pip install joblib
#
## pull scripts from github bin and copy .bashrc, .vimrc, and .inputrc
#RUN git clone https://github.com/wronnyhuang/bin /root/bin
#RUN cp /root/bin/.bashrc /root/
#RUN cp /root/bin/.vimrc /root/bin/.inputrc /root/
#
## install vim plugins
#RUN sh /root/bin/install_vundle.sh
#RUN sh /root/bin/install_commentary_instructions.sh
#
## setup scripts for ssh tunneling, aka copy ngrok and nssh into home
#RUN cp /root/bin/nsshguest /root/bin/nssh /root/bin/ngrok /root/
#
## remove bin folder
#RUN rm -rf /root/bin
#
#WORKDIR "/root"
#CMD [ "/bin/bash" ]



# cache github passwords so dont need to login everytime
RUN git config --global credential.helper cache
RUN apt install screen
