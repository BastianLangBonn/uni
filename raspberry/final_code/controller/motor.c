#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h>

#include "constants.h"
#include "logger.h"
#include "motor.h"

int isBrakeActivated = 0;
extern int currentPwmSignal;

void initializeMotor(){
    char logMessage[256];
    currentPwmSignal = PWM_MINIMUM;
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    logToConsole("Initialized Motor");
}

void decelerate(){
    char logMessage[256];
    softPwmWrite(GPIO_PWM, PWM_MINIMUM+1);
    sprintf(logMessage, "Decelerating, setting signal to %d", PWM_MINIMUM+1);
    logToConsole(logMessage);
    delay(10);
    softPwmWrite(GPIO_PWM, PWM_MINIMUM);
    sprintf(logMessage, "Decelerating, setting signal to %d", PWM_MINIMUM);
    logToConsole(logMessage);
}

void setSpeed(int pwmSignal){
    char logMessage[256];
    softPwmWrite(GPIO_PWM, PWM_MINIMUM);
    sprintf(logMessage, "Setting pwmSignal to %d", pwmSignal);
    logToConsole(logMessage);
}
