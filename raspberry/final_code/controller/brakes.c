#include <stdio.h>
#include "constants.h"
#include "logger.h"
#include "motor.h"

extern int currentBrakeActivation;

void *brakeThreadPtr(void *arg){
    logToConsole("Brake Thread Started");
    int newBrakeActivation;
    while(1){
	    newBrakeActivation = readBrakeSensors();
	    if(newBrakeActivation != currentBrakeActivation){
	        if(newBrakeActivation == 1){
                notifyBrakeActivation();
            }
            currentBrakeActivation = newBrakeActivation;	
	    }
	    
	    delay(SENSOR_UPDATE); //no busy-waiting	
    } 
    logToConsole("Brake Thread Ended");
}

/**
* Reads the GPIO-PINs and returns if at least one of them indicates an 
* activated brake.
*/
int readBrakeSensors(){

    if(digitalRead(GPIO_BRAKE1) == 0){
        return 1;
    }
    
    #ifdef BRAKE2	
        if(digitalRead(GPIO_BRAKE2) == 0){
            return 1;
        }   
    #endif
    
    return 0;    
}
