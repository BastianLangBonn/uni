import RPi.GPIO as GPIO
import parameters as p
import time

def start(pin):
    
    
    currentActivation = p.PWM_MINIMUM
    previousState = 0
    pin.start(currentActivation)
    while True:
        buttonState = GPIO.input(p.GPIO_BUTTON)
        if buttonState and previousState == 0:
            currentActivation += p.PWM_STEP
            if currentActivation > p.PWM_MAXIMUM:
                print 'Activation bigger than maximum: {}, {}'.format(currentActivation, p.PWM_MAXIMUM)
                currentActivation = 4
            print 'New activation: {}'.format(currentActivation)
            pin.ChangeDutyCycle(currentActivation)
            print 'Button pressed'
            time.sleep(p.DELAY_BUTTON)
            print 'stop waiting'

        previousState = buttonState
        time.sleep(p.DELAY_SENSOR)


GPIO.setmode(GPIO.BCM)
GPIO.setup(p.GPIO_BUTTON, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
GPIO.setmode(GPIO.BCM)
GPIO.setup(p.GPIO_PWM,GPIO.OUT)
pin = GPIO.PWM(p.GPIO_PWM,50)
try:
    start(pin)
except KeyboardInterrupt:
    pin.ChangeDutyCycle(4)
    time.sleep(0.1)
    pin.ChangeDutyCycle(3)
    time.sleep(0.1)
    pin.stop()  
    time.sleep(0.1)  
    GPIO.cleanup()
    print 'Interrupted'
