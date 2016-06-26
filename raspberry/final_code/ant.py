#!/usr/bin/python

# Script to receive data from the garmin ant+ stick and 
# serve as a server to provide this data.

import socket
import sys
import time
import serial

# Function to connect to ant+ and send received data to connected
# host
def submitAntData(connection):
        s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        host="localhost"
        port=8168

        s.connect(( host, port ))

        s.send('X-set-channel: 0s\n')
        path = '/home/pi/AMT/out'
        filename = '{}/ant_out_{}'.format(path,time.time());
        f = open(filename, 'w')
        
        # Prevent files from getting too big
        nLines = 0;
        nFiles = 1;

        while True:
            # Receive data from ant+
            data=s.recv(1000000)
            connection.sendall(data);
            print >>sys.stderr, 'sending data: %s' % data  
            f.write('{}\n'.format(data));
            nLines += 1;
            if nLines > 1000000:
                f.close();
                filename = '{}/ant_out_{}_{}'.format(path, nFiles, time.time());
                f = open(filename, 'w');
                nLines = 0;
                nFiles += 1;          
        s.close()

# Function that waits for an incomming connection and then starts submitting data
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