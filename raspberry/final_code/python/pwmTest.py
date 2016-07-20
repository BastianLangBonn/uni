import RPi.GPIO as GPIO
import time
import parameters as p


GPIO.setmode(GPIO.BCM)
GPIO.setup(2,GPIO.OUT)
pin = GPIO.PWM(2,50)
time.sleep(3)
pin.start(1)
for i in range(100):
    pin.ChangeDutyCycle(i)
    time.sleep(1)
pin.stop()
GPIO.cleanup()
    
