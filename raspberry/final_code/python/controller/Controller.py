#!/usr/bin/python
import threading
from Button import Button
import parameters as p
import time
import RPi.GPIO as GPIO

class Controller:
    def __init__(self):
        
        # initialize variables
        self.currentActivation = p.PWM_MINIMUM
        self.activationLock = threading.Lock()
        self.threads = []
        
        # initialize GPIO PINS
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(p.GPIO_BUTTON, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
        
        # initialize threads
        self.button = Button("Button", self)
        self.button.setDaemon(True) # enable keyboard interrupt to end all threads
        self.threads.append(self.button)
        
        
        
    def start(self):
        # start threads
        self.button.start()
        
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
        
        
    
controller = Controller()
controller.start()
