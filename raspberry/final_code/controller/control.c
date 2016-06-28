#include <stdio.h>
#include <pthread.h>

#include "setup.c"
#include "brakes.c"
#include "logger.c"

/*************/
/* VARIABLES */
/*************/
int _currentSpeed = 0;
int _currentBrakeActivation = 0;

int main(){
    int result = setup();
    if(result != 0){
        #ifdef DEBUG
            printf("Error during setup\n");
        #endif
        return result;
    }
    
    char filename[256];
    char logMessage[256];
    sprintf(filename, "/home/pi/AMT/log/log_%d.txt", micros());
    while(1){
        _currentBrakeActivation = checkBrakes(_currentBrakeActivation, _currentSpeed);        
        
        sprintf(logMessage, "timestamp: %d, brakes: %d, current speed:%d", micros(), _currentBrakeActivation, _currentSpeed);
        writeToFile(logMessage, filename);
        delay(SENSOR_UPDATE);
    }    
}
