#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h>

#include "constants.h"
#include "logger.h"
#include "motor.h"

extern int currentBrakeActivation;
extern int currentPwmSignal;
extern int withinLimit;
char logMessage[256];

void decelerate(){
    softPwmWrite(GPIO_PWM, PWM_MINIMUM+2);
    delay(10);
    softPwmWrite(GPIO_PWM, PWM_MINIMUM+1);
    delay(10);
    softPwmWrite(GPIO_PWM, PWM_MINIMUM);
}

void notifyBrakeActivation(){
    // Reset pwm signal if pwm signal > minimum
    if(currentPwmSignal > PWM_MINIMUM){
        decelerate();
    }
    currentPwmSignal = PWM_MINIMUM;
    sprintf(logMessage, "Turning motor off, setting signal to %d", currentPwmSignal);
    logToConsole(logMessage);
}

void notifyLimitReached(){
    decelerate();
    logToConsole("Speed Limit Reached, Turning Off Motor");
}

void notifyLimitLeft(){
    if(currentBrakeActivation == 1){
        // Do nothing
        return;
    }
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    logToConsole("No longer exceeding speed limit, turning motor back on");
}

void notifyPwmSignalChange(){
    if(currentBrakeActivation == 1){
        // Do nothing
        return;
    }
    if(currentPwmSignal == PWM_MINIMUM){
        decelerate;
        logToConsole("Pwm signal set to 0, decelerating");
    } else{
        softPwmWrite(GPIO_PWM, currentPwmSignal);
        logToConsole("Pwm signal has changed, adapting motor speed");
    }
}
