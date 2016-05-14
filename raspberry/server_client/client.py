import socket

#HOST = '130.10.5.38' # The remote host
#PORT = 50007 # The same port as used by the server
try:
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error:
print 'socket not creadted'
try:
s.connect(("130.10.5.38", 9999))
except socket.error,msg:
print 'error in connect'

#s.send('Hello, world')
#data = s.recv(1024)
s.close()
#print 'Received', `data`
