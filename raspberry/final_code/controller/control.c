#include <stdio.h>
#include <pthread.h>

#include "setup.c"
#include "brakes.c"
#include "logger.h"
#include "button.c"
#include "constants.h"
#include "hall.c"

/*************/
/* VARIABLES */
/*************/
extern int currentPwmSignal;
extern int currentBrakeActivation;

int createThreads(){
    pthread_t brakeThread, buttonThread, hallThread;
    int res = 0;

	// Create Brake Thread
	res = pthread_create(&brakeThread, NULL, brakeThreadPtr, NULL);
	if(res != 0){
	    logToConsole("Brake Thread Create Error");
		return res;
	}
	logToConsole("Brake Thread Created");
	
	// Create Button Thread
	res = pthread_create(&buttonThread, NULL, buttonThreadPtr, NULL);
	if(res != 0){
	    logToConsole("Button Thread Create Error");
		return res;
	}
	logToConsole("Button Thread Created");

    // Create Hall Thread
	res = pthread_create(&hallThread, NULL, hallThreadPtr, NULL);
	if(res != 0){
	    logToConsole("Hall Thread Create Error");
		return res;
	}
	logToConsole("Hall Thread Created");

	return res;
}

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
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d", micros(), currentBrakeActivation, currentPwmSignal);
        logToFile(logMessage, filename);
        logToConsole(logMessage);
        delay(SENSOR_UPDATE);
    }    
}
