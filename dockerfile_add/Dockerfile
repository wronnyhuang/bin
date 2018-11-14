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

WORKDIR "/root"
#CMD ["nssh"]
ENTRYPOINT [ "sh", "-c", "/root/bin/nssh"]
#CMD [ "sh", "-c", "/root/bin/nssh"]
