#include <stdio.h>

#include "setup.c"
#include "logger.h"
#include "constants.h"

/*************/
/* VARIABLES */
/*************/
extern int currentPwmSignal;
extern int currentBrakeActivation;

int main(){
    char logMessage[256];    

    int result = setup();
    if(result != 0){
        sprintf(logMessage, "timestamp: %d, Error during setup: %d", micros(), result);
        logToConsole("Error during setup");
        logToFile(logMessage);
        logToConsole(logMessage);
        return result;
    }    
    
    while(1){       
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d, current velocity: %f", micros(), currentBrakeActivation, currentPwmSignal, currentVelocity);
        logToFile(logMessage);
        logToConsole(logMessage);
        delay(SENSOR_UPDATE);
    }    
}
