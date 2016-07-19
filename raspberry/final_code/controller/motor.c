#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h>

#include "constants.h"
#include "logger.h"
#include "motor.h"

int isBrakeActivated = 0;
int currentPwmSignal = PWM_MINIMUM;

void initializeMotor(){
    char logMessage[256];
    currentPwmSignal = PWM_MINIMUM;
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    logToConsole("Initialized Motor");
    sprintf(logMessage, "timestamp: %d, current pwm signal:%d", (int)time(NULL), currentPwmSignal);
    logToFile(pwmLog, logMessage);
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

void notifyBrakeActivation(){
    char logMessage[256];
    // Reset pwm signal if pwm signal > minimum
    int isNeedToChange = (currentPwmSignal > PWM_MINIMUM);
    if(isNeedToChange){
        decelerate();
        currentPwmSignal = PWM_MINIMUM;
        sprintf(logMessage, "Turning motor off, setting signal to %d", currentPwmSignal);
        logToConsole(logMessage);
        //sprintf(logMessage, "timestamp: %d, current pwm signal:%d", (int)time(NULL), currentPwmSignal);
        //logToFile(pwmLog, logMessage);
    }        
}

void notifyBrakeDeactivation(){
    logToConsole("Brake Deactivated");
}

void notifyLimitReached(){
    decelerate();
    logToConsole("Speed Limit Reached, Turning Off Motor");
}

void notifyLimitLeft(){
    if(isBrakeActivated){
        logToConsole("Left Limit, but brake activated");
        return;
    }
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    logToConsole("No longer exceeding speed limit, turning motor back on");
}

void notifyPwmSignalChange(){
    char logMessage[256];
    if(isBrakeActivated){              
        logToConsole("Signal changed, but brake active -> No change");
        return;
    }    
    if(currentPwmSignal < PWM_MAXIMUM){
        currentPwmSignal++;
        softPwmWrite(GPIO_PWM, currentPwmSignal);  
        sprintf(logMessage, "Pwm signal has changed to %d, adapting motor speed", currentPwmSignal);
        logToConsole(logMessage);  
    } else{        
        logToConsole("Pwm signal already reached maximum, no change.");
    }
    sprintf(logMessage, "timestamp: %d, current pwm signal:%d", (int)time(NULL), currentPwmSignal);
    logToFile(pwmLog, logMessage);
    
}
