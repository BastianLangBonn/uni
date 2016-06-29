#include <stdio.h>
#include "constants.h"

extern int currentPwmSignal;

void *buttonThreadPtr(void *arg){
    logToConsole("Button Thread Started");
    while(1){
	    currentPwmSignal = readButton(currentPwmSignal);	
	    delay(SENSOR_UPDATE); //no busy-waiting	
    }
    logToConsole("Button Thread Ended");
}

int readButton(int pwmSignal){
    if(digitalRead(GPIO_BUTTON) == 1){
        pwmSignal++;
        if(pwmSignal > PWM_MAXIMUM){ 
            pwmSignal = PWM_MINIMUM;
        }
	    delay(200); //Delay needed for button press
	}
    return pwmSignal;
}
