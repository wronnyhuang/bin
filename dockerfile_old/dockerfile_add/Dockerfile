FROM wrhuang/rawbase

# apt-get packages
RUN apt-get install -y openssh-server && apt-get clean
RUN apt-get install -y vim && apt-get clean
#RUN apt-get install -y xorg && apt-get clean
#RUN apt-get install -y openbox && apt-get clean

# pull scripts from github bin and copy .bashrc, .vimrc, and .inputrc
RUN git clone https://github.com/wronnyhuang/bin /root/bin # clone my bin folder for useful scripts
RUN cp /root/bin/.bashrc /root/ # replace bashrc file to have colors
RUN cp /root/bin/.vimrc /root/bin/.inputrc /root/ # copy vimrc and inputrc configs into home

# install vim plugins
RUN sh /root/bin/install_vundle.sh
RUN sh /root/bin/install_commentary_instructions.sh

# setup scripts for ssh tunneling
RUN cp /root/bin/nssh /root/bin/ngrok /root/ # permanently store ssh tunneling setup scripts in the image

# remove bin folder
RUN rm -rf /root/bin # remove bin folder (will be mapped later)

# useful python packages
RUN pip install opencv-python
RUN pip install editdistance
RUN pip install comet_ml

# permit root login via ssh
RUN sed -i -e 's/prohibit-password/yes/g' /etc/ssh/sshd_config
RUN service ssh restart
RUN echo 'root:password' | chpasswd

WORKDIR "/root"
CMD [ "/bin/bash" ]
