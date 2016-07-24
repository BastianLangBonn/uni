import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
LED = 3
GPIO.setup(LED, GPIO.OUT)
print("Strg+C beendet das Programm")
p = GPIO.PWM(LED,50)
p.start(0)
try:
    while True:
        for c in range(0, 101, 2):
            p.ChangeDutyCycle(c)
            time.sleep(0.1)
        for c in range(100, -1, -2):
            p.ChangeDutyCycle(c)
            time.sleep(0.1)
except KeyboardInterrupt:
    p.stop()
    GPIO.cleanup()
