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
    pthread_mutex_lock(&pwmMutex);
    if(currentPwmSignal > PWM_MINIMUM){
        decelerate();
    }
    currentPwmSignal = PWM_MINIMUM;
    sprintf(logMessage, "Turning motor off, setting signal to %d", currentPwmSignal);
    logToConsole(logMessage);
    pthread_mutex_unlock(&pwmMutex);
}

void notifyBrakeDeactivation(){
    logToConsole("Brake Deactivated");
}

void notifyLimitReached(){
    decelerate();
    logToConsole("Speed Limit Reached, Turning Off Motor");
}

void notifyLimitLeft(){
    pthread_mutex_lock(&brakeMutex);
    if(currentBrakeActivation == 1){
        pthread_mutex_unlock(&brakeMutex);
        logToConsole("Left Limit, but brake activated");
        return;
    }
    pthread_mutex_unlock(&brakeMutex);
    pthread_mutex_lock(&pwmMutex);
    softPwmWrite(GPIO_PWM, currentPwmSignal);
    pthread_mutex_unlock(&pwmMutex);
    logToConsole("No longer exceeding speed limit, turning motor back on");
}

void notifyPwmSignalChange(){
    pthread_mutex_lock(&brakeMutex);
    if(currentBrakeActivation == 1){
        pthread_mutex_unlock(&brakeMutex);
        pthread_mutex_lock(&pwmMutex);        
        currentPwmSignal = PWM_MINIMUM;
        pthread_mutex_unlock(&pwmMutex);
        logToConsole("Signal changed, but brake active -> No change");
        return;
    }
    pthread_mutex_unlock(&brakeMutex);
    pthread_mutex_lock(&pwmMutex);
    if(currentPwmSignal == PWM_MINIMUM){
        decelerate();
        sprintf(logMessage, "Pwm signal set to minimum of %d, decelerating", currentPwmSignal);
        logToConsole(logMessage);
    } else{
        softPwmWrite(GPIO_PWM, currentPwmSignal);
        sprintf(logMessage, "Pwm signal has changed to %d, adapting motor speed", currentPwmSignal);
        logToConsole(logMessage);
    }
    pthread_mutex_unlock(&pwmMutex);
}
