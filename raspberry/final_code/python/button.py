import RPi.GPIO as GPIO
import parameters as p
import time

def start():
    currentActivation = 0.0
    previousInput = 0
    while True:
        input = GPIO.input(p.GPIO_BUTTON)
        if not previousInput and input:
            print 'Button pressed'
            currentActivation += p.PWM_STEP
            if currentActivation > p.PWM_MAXIMUM:
                print 'Activation bigger than maximum: {}, {}'.format(currentActivation, p.PWM_MAXIMUM)
                currentActivation = p.PWM_MAXIMUM
            print 'New activation: {}'.format(currentActivation)
         
        previousInput = input
        time.sleep(p.DELAY_SENSOR)

GPIO.setmode(GPIO.BOARD)
GPIO.setup(p.GPIO_BUTTON, GPIO.IN)
start()