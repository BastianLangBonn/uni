#!/usr/bin/python
import threading
import parameters as p
import time
import os

class Logger(threading.Thread):
    def __init__(self, name, parentThread):
        super(Logger, self).__init__()
        self.name = name
        self.parentThread = parentThread
        
        self.path = '/home/pi/control/log/{}'.format(int(round(time.time())));
        if not os.path.exists(self.path):
            os.makedirs(self.path)
        self.fileCounter = 1
        #f = open(self.filename, 'w')
        #f.write("timestamp, brake, signal, speed, power, torque, latitude, longitude, altitude\n")
        #f.close()
        
    def run(self):
        print "Starting " + self.name
        while 1:
            self.parentThread.antLock.acquire(1)
            self.parentThread.gpsLock.acquire(1)
            self.parentThread.brakeLock.acquire(1)
            self.parentThread.activationLock.acquire(1)
            f = open('{}/data_{}'.format(self.path,10000000 + self.fileCounter), 'w')
            f.write("{},{},{},{},{},{},{},{},{},{}\n".format(int(round(time.time())), self.parentThread.isBrakeActivated, self.parentThread.currentActivation, self.parentThread.currentSpeed, self.parentThread.currentPower, self.parentThread.currentTorque, self.parentThread.currentLatitude, self.parentThread.currentLongitude, self.parentThread.currentAltitude, self.parentThread.isWithinLimit))
            f.close()
            self.parentThread.antLock.release()
            self.parentThread.gpsLock.release()
            self.parentThread.brakeLock.release()
            self.parentThread.activationLock.release()
            
            self.fileCounter += 1
            time.sleep(p.DELAY_LOGGING)
            
