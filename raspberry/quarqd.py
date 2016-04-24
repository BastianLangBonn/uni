#!/usr/bin/python

# Script to receive data from the garmin ant+ stick and 
# pipe it to stdin, where it can be read by "./dataread".

import subprocess as sp
import socket
import sys

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host="localhost"
port=8168

s.connect(( host, port ))

s.send('X-set-channel: 0s\n')

while True:
    # Receive data from ant+
    data=s.recv(1000000)
    # 
    proc = sp.Popen("./steuerung", stdin=sp.PIPE)
    out, err = proc.communicate(data);

s.close()
