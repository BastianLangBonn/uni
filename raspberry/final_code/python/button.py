import RPi.GPIO as GPIO
import parameters as p
import time

def start():
    currentActivation = 0.0
    previousState = 0
    while True:
        buttonState = GPIO.input(p.GPIO_BUTTON)
        if buttonState and previousState == 0:
            currentActivation += p.PWM_STEP
            if currentActivation > p.PWM_MAXIMUM:
                print 'Activation bigger than maximum: {}, {}'.format(currentActivation, p.PWM_MAXIMUM)
                currentActivation = p.PWM_MAXIMUM
            print 'New activation: {}'.format(currentActivation)
            print 'Button pressed'
            time.sleep(p.DELAY_BUTTON)
            print 'stop waiting'

        previousState = buttonState
        time.sleep(p.DELAY_SENSOR)

GPIO.setmode(GPIO.BCM)
GPIO.setup(p.GPIO_BUTTON, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)
start()
