import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
LED = 3
GPIO.setup(LED, GPIO.OUT)
GPIO.setup(11, GPIO.IN, pull_up_down=GPIO.PUD_UP)
print("Strg+C beendet das Programm")
p = GPIO.PWM(LED,50)
p.start(0)
pwm = 0
try:
    while True:
        
        input_state = GPIO.input(11)
        if input_state == False:
            pwm += 5
            if(pwm > 100):
                pwm = 0
            p.ChangeDutyCycle(pwm)
            print('Button Pressed, pwm = {}'.format(pwm))
            time.sleep(0.2)
except KeyboardInterrupt:
    p.stop()
    GPIO.cleanup()
