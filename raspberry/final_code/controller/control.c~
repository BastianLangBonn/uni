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
        pthread_mutex_lock(&velocityMutex);  
        pthread_mutex_lock(&brakeMutex);   
        pthread_mutex_lock(&pwmMutex);
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d, current velocity: %lf, current longitude: %.4lf, current latitude: %.4lf, current altitude: %.2lf, currentPower: %.2lf, currentTorque: %.2lf", (int)time(NULL), currentBrakeActivation, currentPwmSignal, currentVelocity, currentLongitude, currentLatitude, currentAltitude, currentPower, currentTorque);
        pthread_mutex_unlock(&pwmMutex);
        pthread_mutex_unlock(&brakeMutex);
        pthread_mutex_unlock(&velocityMutex);
        
        logToFile(logMessage);
        //logToConsole(logMessage);
        delay(LOGGING_UPDATE);
    }    
}
