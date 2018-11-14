FROM wrhuang/rawbase

RUN pip install opencv-python
RUN apt-get install -y openssh-server && apt-get clean
#RUN apt-get install -y xorg && apt-get clean
#RUN apt-get install -y openbox && apt-get clean
RUN pip install editdistance
RUN git clone https://github.com/wronnyhuang/bin /root/bin
RUN cp /root/bin/.bashrc /root/
RUN cp /root/bin/nssh /root/bin/ngrok /root/
RUN rm -rf /root/bin
RUN echo "echo hello" > /root/echofile
RUN chmod +x /root/echofile

WORKDIR "/root"
#CMD ["nssh"]
#ENTRYPOINT [ "/root/bin/nssh", "--"]
#ENTRYPOINT [ "/usr/bin/tini", "--" ]
ENTRYPOINT [ "sh", "-c", "/root/bin/echofile" ]
CMD [ "/bin/bash" ]
#CMD [ "sh", "-c", "/root/bin/nssh"]
