#!/usr/bin/python
import threading
from Button import Button
from Brake import Brake
from ant import Ant
from Gps import Gps
from Logger import Logger
import parameters as p
import time
import RPi.GPIO as GPIO

class Controller:
    def __init__(self):
        
        # initialize variables
        self.currentActivation = p.PWM_MINIMUM
        self.previousActivation = p.PWM_ACTIVE_MINIMUM # to ensure initial sending of signal
        self.isBrakeActivated = False
        self.isWithinLimit = True
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
        
        # initialize GPIO PINS
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(p.GPIO_BUTTON, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
        GPIO.setup(p.GPIO_BRAKE, GPIO.IN)
        GPIO.setup(p.GPIO_PWM,GPIO.OUT)
        self.pin = GPIO.PWM(p.GPIO_PWM,50)
        self.pin.start(self.currentActivation)
        
        # initialize threads
        self.button = Button("Button", self)
        self.brake = Brake("Brake", self)
        self.ant = Ant("Ant", self)
        self.gps = Gps("Gps", self)
        self.logger = Logger("Logger", self)
        
        # declarate threads as daemons for keyboard interrupt
        self.button.setDaemon(True) 
        self.brake.setDaemon(True)
        self.ant.setDaemon(True)
        self.gps.setDaemon(True)
        self.logger.setDaemon(True)

        
    def start(self):
        # start threads
        self.button.start()
        self.brake.start()
        self.ant.start()
        self.gps.start()
        self.logger.start()
        
        # wait for threads to end
        try:
            while threading.active_count() > 0:
                self.setMotorSpeed();
                time.sleep(p.DELAY_MOTOR)
        except KeyboardInterrupt:
            self.pin.ChangeDutyCycle(4)
            time.sleep(0.1)
            self.pin.ChangeDutyCycle(3)
            time.sleep(0.1)
            self.pin.stop()  
            time.sleep(0.1)  
            GPIO.cleanup()
            print 'Interrupted'
        except:
            self.pin.ChangeDutyCycle(4)
            time.sleep(0.1)
            self.pin.ChangeDutyCycle(3)
            time.sleep(0.1)
            self.pin.stop()  
            time.sleep(0.1)  
            GPIO.cleanup()
            print 'Unknown exception'
            raise
            
        print "Exiting Main Thread"
        
    def notifyButtonPress(self):
        print "Button has been pressed"
        self.brakeLock.acquire(1)
        if not self.isBrakeActivated:
            self.activationLock.acquire(1)
            self.currentActivation += p.PWM_STEP
            if self.currentActivation > p.PWM_MAXIMUM:
                self.currentActivation = p.PWM_MAXIMUM
            elif self.currentActivation < p.PWM_ACTIVE_MINIMUM:
                self.currentActivation = p.PWM_ACTIVE_MINIMUM + p.PWM_STEP
            print "Activation set to {}".format(self.currentActivation)
            self.activationLock.release()            
        self.brakeLock.release()
        
    def notifyBrakeDeactivation(self):
        if self.isBrakeActivated:
            self.brakeLock.acquire(1)
            self.isBrakeActivated = False
            self.brakeLock.release()
        
    def notifyBrakeActivation(self):
        if not self.isBrakeActivated:
            self.brakeLock.acquire(1)
            self.activationLock.acquire(1)
            self.isBrakeActivated = True
            self.currentActivation = p.PWM_ACTIVE_MINIMUM
            self.brakeLock.release()
            self.activationLock.release()
            
    def notifySpeedUpdate(self, rpm):
        self.antLock.acquire(1)
        self.currentSpeed = rpm * p.WHEEL_LENGTH * 0.06
        if self.isWithinLimit and self.currentSpeed > p.MAX_TEMPO:
            self.isWithinLimit = False
        elif not self.isWithinLimit and self.currentSpeed <= p.MAX_TEMPO:
            self.isWithinLimit = True
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
        self.gpsLock.release()
        
    def setMotorSpeed(self):
        self.activationLock.acquire(1)
        self.antLock.acquire(1)
        
        
        if self.previousActivation != self.currentActivation:
            if self.currentActivation == p.PWM_ACTIVE_MINIMUM:
                self.pin.ChangeDutyCycle(p.PWM_ACTIVE_MINIMUM+1)
                time.sleep(0.1)
                self.pin.ChangeDutyCycle(p.PWM_ACTIVE_MINIMUM)
                self.previousActivation = p.PWM_ACTIVE_MINIMUM
            elif self.isWithinLimit:
                self.pin.ChangeDutyCycle(self.currentActivation)
                self.previousActivation = self.currentActivation
            elif not self.isWithinLimit and self.previousActivation != p.PWM_ACTIVE_MINIMUM:
                self.pin.ChangeDutyCycle(p.PWM_ACTIVE_MINIMUM+1)
                time.sleep(0.1)
                self.pin.ChangeDutyCycle(p.PWM_ACTIVE_MINIMUM)
                self.previousActivation = p.PWM_ACTIVE_MINIMUM
            
        
        
        self.activationLock.release()
        self.antLock.release()
    
controller = Controller()
controller.start()