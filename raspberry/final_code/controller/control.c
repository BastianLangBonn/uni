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
    char filename[256];
    sprintf(filename, "/home/pi/AMT/log/log_%d.txt", micros());
    currentPwmSignal = PWM_MINIMUM;
    currentBrakeActivation = 0;

    int result = setup();
    if(result != 0){
        sprintf(logMessage, "timestamp: %d, Error during setup: %d", micros(), result);
        logToConsole("Error during setup");
        logToFile(logMessage, filename);
        logToConsole(logMessage);
        return result;
    }
    
    createThreads();
    
    while(1){       
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d, current velocity: %f", micros(), currentBrakeActivation, currentPwmSignal, currentVelocity);
        logToFile(logMessage, filename);
        logToConsole(logMessage);
        delay(SENSOR_UPDATE);
    }    
}
