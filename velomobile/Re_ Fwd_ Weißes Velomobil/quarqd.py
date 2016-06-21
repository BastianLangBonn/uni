#!/usr/bin/python

import subprocess as sp
import socket
import sys

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host="localhost"
port=8168

s.connect(( host, port ))

#s.send('X-set-channel: 0p\n')
s.send('X-set-channel: 0s\n')

while True:
    data=s.recv(1000000)
    proc = sp.Popen("./dataread", stdin=sp.PIPE)
    out, err = proc.communicate(data);
    #if not data:
    #    break

s.close()
