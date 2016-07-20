#!/usr/bin/python
import threading
import parameters as p
import time
import socket

class Ant(threading.Thread):
    def __init__(self, name, parentThread):
        super(Ant, self).__init__()
        self.name = name
        self.parentThread = parentThread
        
    def handleData(self, data):
        # handle Speed
        if '<Speed' in data:
            splitted = data.split()
            if "RPM" in splitted[3]:
                rpm = splitted[3].replace("'","").replace("RPM=","")
                rpm = float(rpm)
                self.parentThread.notifySpeedUpdate(rpm)
        # handle Power
        elif '<Power' in data:
            splitted = data.split()
            if "watts" in splitted[3]:
                power = splitted[3].replace("'","").replace("watts=","")
                power = float(power)
                self.parentThread.notifyPowerUpdate(power)
                
        # handle Torque
        elif '<Torque' in data:
            splitted = data.split()
            if "Nm" in splitted[3]:
                torque = splitted[3].replace("'","").replace("Nm=","")
                torque = float(torque)
                self.parentThread.notifyTorqueUpdate(torque)
        
    def run(self):
        print "Starting " + self.name
        print 'ANT Connection started'
        s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        host="localhost"
        port=8168

        s.connect(( host, port ))

        s.send('X-set-channel: 0s\n')
        s.send('X-set-channel: 0p\n')
        path = '/home/pi/control/out'
        filename = '{}/ant_out_{}.txt'.format(path,int(round(time.time())));
        f = open(filename, 'w')
        
        # Prevent files from getting too big
        nLines = 0;
        nFiles = 1;

        while True:
            # Receive data from ant+
            data=s.recv(1000000)
            f.write('{}: {}\n'.format(int(round(time.time())),data));
            nLines += 1;
            if nLines > 1000000:
                f.close();
                filename = '{}/ant_out_{}_{}'.format(path, nFiles, int(round(time.time())));
                f = open(filename, 'w');
                nLines = 0;
                nFiles += 1;          
            self.handleData(data)
        s.close()
        
