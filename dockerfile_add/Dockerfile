FROM wrhuang/rawbase

RUN pip install opencv-python
RUN apt-get install -y openssh-server && apt-get clean
RUN apt-get install -y vim && apt-get clean
RUN pip install editdistance
#RUN apt-get install -y xorg && apt-get clean
#RUN apt-get install -y openbox && apt-get clean
RUN git clone https://github.com/wronnyhuang/bin /root/bin # clone my bin folder for useful scripts
RUN cp /root/bin/.bashrc /root/ # replace bashrc file to have colors
RUN cp /root/bin/nssh /root/bin/ngrok /root/ # permanently store ssh tunneling setup scripts in the image
RUN rm -rf /root/bin # remove bin folder (will be mapped later)

WORKDIR "/root"
CMD [ "/bin/bash" ]
