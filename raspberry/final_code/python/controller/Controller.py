#!/usr/bin/python
import threading
from Button import Button
from Brake import Brake
from ant import Ant
from Gps import Gps
import parameters as p
import time
import RPi.GPIO as GPIO

class Controller:
    def __init__(self):
        
        # initialize variables
        self.currentActivation = p.PWM_MINIMUM
        self.isBrakeActivated = False
        self.currentPower = 0.0
        self.currentSpeed = 0.0
        self.currentTorque = 0.0
        self.currentLatitude = 0.0
        self.currentLongitude = 0.0
        self.currentAltitude = 0.0
        
        self.activationLock = threading.Lock()
        self.brakeLock = threading.Lock()
        self.antLock = threading.Lock()
        self.gpsLock = threading.Lock()
        self.threads = []
        
        # initialize GPIO PINS
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(p.GPIO_BUTTON, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
        GPIO.setup(p.GPIO_BRAKE, GPIO.IN)
        
        # initialize threads
        self.button = Button("Button", self)
        self.brake = Brake("Brake", self)
        self.ant = Ant("Ant", self)
        self.gps = Gps("Gps", self)
        
        # declarate threads as daemons for keyboard interrupt
        self.button.setDaemon(True) 
        self.brake.setDaemon(True)
        self.ant.setDaemon(True)
        self.gps.setDaemon(True)
        self.threads.append(self.button)
        self.threads.append(self.brake)
        self.threads.append(self.ant)
        self.threads.append(self.gps)
        
        
    def start(self):
        # start threads
        self.button.start()
        self.brake.start()
        self.ant.start()
        self.gps.start()
        
        # wait for threads to end
        while threading.active_count() > 0:
            time.sleep(0.1)
        print "Exiting Main Thread"
        
    def notifyButtonPress(self):
        print "Button has been pressed"
        self.activationLock.acquire(1)
        self.currentActivation += p.PWM_STEP
        if self.currentActivation > p.PWM_MAXIMUM:
            self.currentActivation = p.PWM_MAXIMUM
        print "Activation set to {}".format(self.currentActivation)
        self.activationLock.release()
        
    def notifyBrakeDeactivation(self):
        if self.isBrakeActivated:
            self.brakeLock.acquire(1)
            self.isBrakeActivated = False
            self.brakeLock.release()
        
    def notifyBrakeActivation(self):
        if not self.isBrakeActivated:
            self.brakeLock.acquire(1)
            self.isBrakeActivated = True
            self.brakeLock.release()
            
    def notifySpeedUpdate(self, rpm):
        self.antLock.acquire(1)
        self.currentSpeed = rpm * p.WHEEL_LENGTH * 0.06
        print "Speed set to {}".format(self.currentSpeed)
        self.antLock.release()
        
    
    def notifyPowerUpdate(self, power):
        self.antLock.acquire(1)
        self.currentPower = power
        print "Power set to {}".format(self.currentPower)
        self.antLock.release()
        
    
    def notifyTorqueUpdate(self, torque):
        self.antLock.acquire(1)
        self.currentTorque = torque
        print "Torque set to {}".format(self.currentTorque)
        self.antLock.release()
        
    def notifyGpsUpdate(self, latitude, longitude, altitude):
        self.gpsLock.acquire(1)
        self.currentLatitude = latitude
        self.currentLongitude = longitude
        self.currentAltitude = altitude
        print "Set gps data to {},{},{}".format(self.currentLatitude, self.currentLongitude, self.currentAltitude)
        self.gpsLock.release()
        
    
controller = Controller()
controller.start()
