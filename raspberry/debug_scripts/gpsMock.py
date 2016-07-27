# GPGGA,120006.000,0000.0000,N,00000.0000,E,0,00,0.0,0.0,M,0.0,M,,0000*68
import serial
import sys
import time
import socket
def listenForConnection():
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Bind the socket to the port
    server_address = ('localhost', 2300)
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
                connection.sendall('GPGGA,120006.000,0000.0000,N,00000.0000,E,0,00,0.0,0.0,M,0.0,M,,0000*68\n')
                time.sleep(0.1)

        finally:
            # Clean up the connection
            connection.close()
            
listenForConnection();
