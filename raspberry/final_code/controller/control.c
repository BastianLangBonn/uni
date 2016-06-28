#include <stdio.h>
#include <pthread.h>

#include "setup.c"
#include "brakes.c"
#include "logger.c"
#include "button.c"

/*************/
/* VARIABLES */
/*************/
int currentPwmSignal = PWM_MINIMUM;
int currentBrakeActivation = 0;

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
        currentBrakeActivation = readBrakeSensors();        
        currentPwmSignal = readButton(currentPwmSignal);
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d", micros(), currentBrakeActivation, currentPwmSignal);
        writeToFile(logMessage, filename);
        delay(SENSOR_UPDATE);
    }    
}
