#!/usr/bin/python

# Script to receive data from the garmin ant+ stick and 
# pipe it to stdin, where it can be read by "./dataread".

import socket
import sys

def submitAntData(connection):
        s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        host="localhost"
        port=8168

        s.connect(( host, port ))

        s.send('X-set-channel: 0s\n')

        while True:
            # Receive data from ant+
            print >>sys.stderr, 'sending data...'
            data=s.recv(1000000)
            connection.sendall(data);            
            
            
            # proc = sp.Popen("./steuerung", stdin=sp.PIPE)
            # out, err = proc.communicate(data);

        s.close()

def listenForConnection():
    
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    # Bind the socket to the port
    server_address = ('localhost', 2301)
    print >>sys.stderr, 'starting up on %s port %s' % server_address
    sock.bind(server_address)
    
    # Listen for incoming connections
    sock.listen(1)

    while True:
        # Wait for a connection
        print >>sys.stderr, 'waiting for a connection'
        connection, client_address = sock.accept()
        try:
            print >>sys.stderr, 'connection from', client_address

            # Receive the data and transmit it
            while True:
                submitAntData(connection)

        finally:
            # Clean up the connection
            connection.close()

listenForConnection();