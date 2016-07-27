#<Speed id='5178s' timestamp='1467311252.48' RPM='49.00' />
#<Power id='51624p' timestamp='1467803229.60' watts='85.67' />
#<Torque id='51624p' timestamp='1467803229.60' Nm='64.12' />

import serial
import sys
import time
import socket

def listenForConnection():
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Bind the socket to the port
    server_address = ('localhost', 8168)
    print >>sys.stderr, 'starting up on %s port %s' % server_address
    sock.bind(server_address)
    # Listen for incoming connections
    sock.listen(1)
    
    counter = 0;

    while True:
        # Wait for a connection
        print >>sys.stderr, 'waiting for a connection'
        connection, client_address = sock.accept()
        try:
            print >>sys.stderr, 'connection from', client_address

            # Receive the data and transmit it
            while True:
                connection.sendall("<Speed id='5178s' timestamp='1467311252.48' RPM='49.00' />\n")
                time.sleep(0.1)
                connection.sendall("<Power id='51624p' timestamp='1467803229.60' watts='85.67' />\n")
                time.sleep(0.1)
                connection.sendall("<Torque id='51624p' timestamp='1467803229.60' Nm='64.12' />\n")
                time.sleep(0.1)

        finally:
            # Clean up the connection
            connection.close()
            
listenForConnection();
