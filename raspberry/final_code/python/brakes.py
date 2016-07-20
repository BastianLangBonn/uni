import RPi.GPIO as GPIO
import time
import parameters as p

GPIO.setmode(GPIO.BCM)

GPIO.setup(p.GPIO_BRAKE, GPIO.IN)

oldActivation = True

while 1:
    isBrakeActivated = (GPIO.input(p.GPIO_BRAKE) == GPIO.HIGH)
    if isBrakeActivated:
        if oldActivation == True:
            oldActivation = False
            print 'Brake Deactivated'
            # Notify Motor
    else: 
        if oldActivation == False:
            oldActivation = True
            print 'Brake Activated'
            # Notify Motor
            
    time.sleep(0.1) 
