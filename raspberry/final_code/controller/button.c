#include <stdio.h>
#include "constants.h"
#include "motor.h"

void readButton(){
    if(digitalRead(GPIO_BUTTON) == 1){
        notifyPwmSignalChange();
	    delay(200); //Delay needed for button press
	}
}

void *buttonThreadPtr(void *arg){
    logToConsole("Button Thread Started");
    while(1){
	    readButton();	
	    delay(SENSOR_UPDATE); //no busy-waiting	
    }
    logToConsole("Button Thread Ended");
}


