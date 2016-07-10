import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)

GPIO.setup(12, GPIO.IN)

oldActivation = True

while 1:
    if GPIO.input(12) == GPIO.HIGH:
        if oldActivation == True:
            oldActivation = False
            print 'Brake Deactivated'
            # Notify Motor
    elif GPIO.input(12) == GPIO.LOW: 
        if oldActivation == False:
            oldActivation = True
            print 'Brake Activated'
            # Notify Motor
            
    time.sleep(0.1) 
