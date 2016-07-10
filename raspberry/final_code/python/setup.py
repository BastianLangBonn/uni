import RPi.GPIO as GPIO
import time
import parameters as p
import button
import brakes
import motor
import thread

def setup():
    # Setup Pins
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(p.GPIO_BUTTON, GPIO.IN)
    GPIO.setup(p.GPIO_BRAKE, GPIO.IN)
    GPIO.setup(p.GPIO_PWM, GPIO.OUT)
    
    # Run Threads
    thread.start_new_thread( button.start, None )
    thread.start_new_thread( brakes.start, None )
    thread.start_new_thread( motor.start, None )
