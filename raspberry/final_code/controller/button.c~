#include <stdio.h>
#include "constants.h"
#include "motor.h"

extern int currentPwmSignal;

void readButton(){
    //pthread_mutex_lock(&pwmMutex);
    int pwmSignal = currentPwmSignal;
    //pthread_mutex_unlock(&pwmMutex);
    if(digitalRead(GPIO_BUTTON) == 1){
        pwmSignal++;
        if(pwmSignal > PWM_MAXIMUM){ 
            pwmSignal = PWM_MAXIMUM;
        }
        //pthread_mutex_lock(&pwmMutex);
        if(currentPwmSignal != pwmSignal){
            currentPwmSignal = pwmSignal;
            notifyPwmSignalChange();
        }        
        //pthread_mutex_unlock(&pwmMutex);
        
	    delay(200); //Delay needed for button press
	}
}

void *buttonThreadPtr(void *arg){
    logToConsole("Button Thread Started");
    notifyPwmSignalChange();
    while(1){
	    readButton();	
	    delay(SENSOR_UPDATE); //no busy-waiting	
    }
    logToConsole("Button Thread Ended");
}


