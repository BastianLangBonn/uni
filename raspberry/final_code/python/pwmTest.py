import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(3,GPIO.OUT)
p = GPIO.PWM(3,10.0)
p.start(50.0)
