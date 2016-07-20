#!/usr/bin/python
import threading
from Button import Button
from Brake import Brake
import parameters as p
import time
import RPi.GPIO as GPIO

class Controller:
    def __init__(self):
        
        # initialize variables
        self.currentActivation = p.PWM_MINIMUM
        self.isBrakeActivated = False
        self.activationLock = threading.Lock()
        self.brakeLock = threading.Lock()
        self.threads = []
        
        # initialize GPIO PINS
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(p.GPIO_BUTTON, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
        GPIO.setup(p.GPIO_BRAKE, GPIO.IN)
        
        # initialize threads
        self.button = Button("Button", self)
        self.brake = Brake("Brake", self)
        
        # declarate threads as daemons for keyboard interrupt
        self.button.setDaemon(True) 
        self.brake.setDaemon(True)
        self.threads.append(self.button)
        self.threads.append(self.brake)
        
        
        
    def start(self):
        # start threads
        self.button.start()
        self.brake.start()
        
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
        
        
    
controller = Controller()
controller.start()
