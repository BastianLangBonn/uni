#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h>

#include "constants.h"
#include "logger.h"
#include "motor.h"

extern int currentBrakeActivation;
extern int currentPwmSignal;
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
    //pthread_mutex_lock(&pwmMutex);
    int isNotableCommand = currentPwmSignal > PWM_MINIMUM;
    //pthread_mutex_unlock(&pwmMutex);
    if(isNotableCommand){
        decelerate();
    }
    //pthread_mutex_lock(&pwmMutex);
    currentPwmSignal = PWM_MINIMUM;
    sprintf(logMessage, "Turning motor off, setting signal to %d", currentPwmSignal);
    //pthread_mutex_unlock(&pwmMutex);
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
    //pthread_mutex_lock(&brakeMutex);
    int isBrakeActivated = currentBrakeActivation;
    //pthread_mutex_lock(&brakeMutex);
    if(isBrakeActivated){
        logToConsole("Left Limit, but brake activated");
        return;
    }
    //pthread_mutex_lock(&pwmMutex);
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    //pthread_mutex_unlock(&pwmMutex);
    logToConsole("No longer exceeding speed limit, turning motor back on");
}

void notifyPwmSignalChange(){
    //pthread_mutex_lock(&brakeMutex);
    int isBrakeActivated = currentBrakeActivation;
    //pthread_mutex_unlock(&brakeMutex);
    if(isBrakeActivated){        
        //pthread_mutex_lock(&pwmMutex);        
        currentPwmSignal = PWM_MINIMUM;
        //pthread_mutex_unlock(&pwmMutex);
        logToConsole("Signal changed, but brake active -> No change");
        return;
    }
    //pthread_mutex_lock(&pwmMutex);
    int isMinimalSignal = currentPwmSignal == PWM_MINIMUM;
    if(isMinimalSignal){
        decelerate();
        sprintf(logMessage, "Pwm signal set to minimum of %d, decelerating", currentPwmSignal);
        logToConsole(logMessage);
    } else{
        softPwmWrite(GPIO_PWM, currentPwmSignal);
        sprintf(logMessage, "Pwm signal has changed to %d, adapting motor speed", currentPwmSignal);
        logToConsole(logMessage);
    }
    //pthread_mutex_unlock(&pwmMutex);
}
