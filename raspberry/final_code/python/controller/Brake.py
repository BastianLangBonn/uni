#!/usr/bin/python
import threading
import parameters as p
import time
import RPi.GPIO as GPIO

class Brake(threading.Thread):
    def __init__(self, name, parentThread):
        super(Brake, self).__init__()
        self.name = name
        self.gpio = p.GPIO_BRAKE
        self.parentThread = parentThread
        
    def run(self):
        print "Starting " + self.name
        oldActivation = True

        while 1:
            isBrakeActivated = (GPIO.input(self.gpio) == GPIO.HIGH)
            if isBrakeActivated:
                if oldActivation == True:
                    oldActivation = False
                    print 'Brake Deactivated'
                    self.parentThread.notifyBrakeDeactivation()
            else: 
                if oldActivation == False:
                    oldActivation = True
                    print 'Brake Activated'
                    self.parentThread.notifyBrakeActivation()
                    
            time.sleep(p.DELAY_SENSOR) 
