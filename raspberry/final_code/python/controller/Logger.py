#!/usr/bin/python
import threading
import parameters as p
import time

class Logger(threading.Thread):
    def __init__(self, name, parentThread):
        super(Logger, self).__init__()
        self.name = name
        self.parentThread = parentThread
        self.filename = '/home/pi/control/log/data_{}.txt'.format(int(round(time.time())));
        f = open(self.filename, 'w')
        f.write("timestamp, brake, signal, speed, power, torque, latitude, longitude, altitude\n")
        f.close()
        
    def run(self):
        print "Starting " + self.name
        while 1:
            self.parentThread.antLock.acquire(1)
            self.parentThread.gpsLock.acquire(1)
            self.parentThread.brakeLock.acquire(1)
            self.parentThread.activationLock.acquire(1)
            f = open(self.filename, 'a')
            f.write("{},{},{},{},{},{},{},{},{}\n".format(int(round(time.time())), self.parentThread.isBrakeActivated, self.parentThread.currentActivation, self.parentThread.currentSpeed, self.parentThread.currentPower, self.parentThread.currentTorque, self.parentThread.currentLatitude, self.parentThread.currentLongitude, self.parentThread.currentAltitude))
            f.close()
            self.parentThread.antLock.release()
            self.parentThread.gpsLock.release()
            self.parentThread.brakeLock.release()
            self.parentThread.activationLock.release()
            
            time.sleep(p.DELAY_LOGGING)
            
