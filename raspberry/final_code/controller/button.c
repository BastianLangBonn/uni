#include <stdio.h>
#include "constants.h"
#include "motor.h"

extern int currentPwmSignal;

void readButton(){
    int pwmSignal = currentPwmSignal;
    if(digitalRead(GPIO_BUTTON) == 1){
        pwmSignal++;
        if(pwmSignal > PWM_MAXIMUM){ 
            pwmSignal = PWM_MINIMUM;
        }
        currentPwmSignal = pwmSignal;
        notifyPwmSignalChange();
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


