#include <stdio.h>

#include "setup.c"
#include "logger.h"
#include "constants.h"

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
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d, current velocity: %f, current longitude: %.2f, current latitude: %.2f, current altitude: %.2f, currentPower: %.2f, currentTorque: %.2f", micros(), currentBrakeActivation, currentPwmSignal, currentVelocity, currentLongitude, currentLatitude, currentAltitude, currentPower, currentTorque);
        logToFile(logMessage);
        //logToConsole(logMessage);
        delay(SENSOR_UPDATE);
    }    
}
