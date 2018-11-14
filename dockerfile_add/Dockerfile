FROM wrhuang/base

RUN pip install opencv-python
RUN apt-get install -y openssh-server && apt-get clean
#RUN apt-get install -y xorg && apt-get clean
#RUN apt-get install -y openbox && apt-get clean
RUN pip install editdistance
RUN git clone https://github.com/wronnyhuang/bin
RUN echo nssh >> ~/.bashrc

WORKDIR "/root"
CMD ["nssh"]
