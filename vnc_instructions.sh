#!/usr/bin/env bash
# instructions obtained here https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-18-04
# on server computer, run vncserver (kill old ones with vncserver -kill :1)
# on client (laptop), run ssh -L 5901:127.0.0.1:5901 -X -C -N -l ronny tricky.cs.umd.edu