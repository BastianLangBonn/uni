#include <stdio.h>
#include "constants.h"
#include "logger.h"
#include "motor.h"

int isBrakeActivated;

void readButton(){
    if(digitalRead(GPIO_BUTTON) == 1){
        notifyPwmSignalChange();
        delay(200); //Delay needed for button press
    }
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

void *sensorThreadPtr(void *arg){
    char logMessage[256];
    logToConsole("Sensor Thread Started");
    int newBrakeActivation;
    isBrakeActivated = 0;
    while(1){
	    newBrakeActivation = readBrakeSensors();
	    if(newBrakeActivation != isBrakeActivated){
	        if(newBrakeActivation == 1){
                notifyBrakeActivation();
            }else{
                notifyBrakeDeactivation();
            }
            isBrakeActivated = newBrakeActivation;	
	    }	    
	    readButton();
	    
	    // Logging
	    sprintf(logMessage, "timestamp: %d, brakes: %d", (int)time(NULL), isBrakeActivated);
	    logToFile(sensorLog, logMessage);
	    	
	    delay(SENSOR_UPDATE); //no busy-waiting	
    } 
    logToConsole("Sensor Thread Ended");
}
