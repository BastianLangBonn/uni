#!/usr/bin/python
import threading
import parameters as p
import time
import RPi.GPIO as GPIO

class Button(threading.Thread):
    def __init__(self, name, parentThread):
        super(Button, self).__init__()
        self.name = name
        self.gpio = p.GPIO_BUTTON
        self.parentThread = parentThread
        
    def run(self):
        print "Starting " + self.name
        previousState = 0
        while True:
            buttonState = GPIO.input(self.gpio)
            if buttonState == 1 and previousState == 0:
                print 'Button pressed'
                self.parentThread.notifyButtonPress()
                time.sleep(p.DELAY_BUTTON)
                print 'stop waiting'

            previousState = buttonState
            time.sleep(p.DELAY_SENSOR)
