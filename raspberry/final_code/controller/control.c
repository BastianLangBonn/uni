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

void *buttonThreadPtr(void *arg){
    while(1){
	    currentPwmSignal = readButton(currentPwmSignal);	
	    delay(SENSOR_UPDATE); //no busy-waiting	
    }
    logToConsole("Button Thread ended\n"); 
}

void *brakeThreadPtr(void *arg){
    while(1){
	    currentBrakeActivation = readBrakeSensors();	
	    delay(SENSOR_UPDATE); //no busy-waiting	
    }
    logToConsole("Brake Thread ended"); 
}

int createThreads(){
    pthread_t brakeThread, buttonThread;
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

	return res;
}

int main(){
    char logMessage[256];
    char filename[256];
    sprintf(filename, "/home/pi/AMT/log/log_%d.txt", micros());

    int result = setup();
    if(result != 0){
        sprintf(logMessage, "timestamp: %d, Error during setup: %d", micros(), result);
        logToConsole("Error during setup");
        logToFile(logMessage, filename);
        logToConsole(logMessage);
        return result;
    }
    
    while(1){       
        sprintf(logMessage, "timestamp: %d, brakes: %d, current pwm signal:%d", micros(), currentBrakeActivation, currentPwmSignal);
        logToFile(logMessage, filename);
        logToConsole(logMessage);
        delay(SENSOR_UPDATE);
    }    
}
