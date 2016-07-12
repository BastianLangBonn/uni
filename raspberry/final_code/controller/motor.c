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
    /*softPwmWrite(GPIO_PWM, PWM_MINIMUM+2);
    sprintf(logMessage, "Decelerating, setting signal to %d", PWM_MINIMUM+2);
    logToConsole(logMessage);
    delay(10);*/
    softPwmWrite(GPIO_PWM, PWM_MINIMUM+1);
    sprintf(logMessage, "Decelerating, setting signal to %d", PWM_MINIMUM+1);
    logToConsole(logMessage);
    delay(10);
    softPwmWrite(GPIO_PWM, PWM_MINIMUM);
    sprintf(logMessage, "Decelerating, setting signal to %d", PWM_MINIMUM);
    logToConsole(logMessage);
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

void notifyBrakeDeactivation(){
    logToConsole("Brake Deactivated");
}

void notifyLimitReached(){
    decelerate();
    logToConsole("Speed Limit Reached, Turning Off Motor");
}

void notifyLimitLeft(){
    if(currentBrakeActivation == 1){
        logToConsole("Left Limit, but brake activated");
        return;
    }
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    logToConsole("No longer exceeding speed limit, turning motor back on");
}

void notifyPwmSignalChange(){
    if(currentBrakeActivation == 1){
        currentPwmSignal = PWM_MINIMUM;
        logToConsole("Signal changed, but brake active -> No change");
        return;
    }
    if(currentPwmSignal == PWM_MINIMUM){
        decelerate();
        sprintf(logMessage, "Pwm signal set to minimum of %d, decelerating", currentPwmSignal);
        logToConsole(logMessage);
    } else{
        softPwmWrite(GPIO_PWM, currentPwmSignal);
        sprintf(logMessage, "Pwm signal has changed to %d, adapting motor speed", currentPwmSignal);
        logToConsole(logMessage);
    }
}