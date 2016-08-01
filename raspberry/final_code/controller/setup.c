/* Method that sets up all needed pins */
#include <wiringPi.h>
#include <softPwm.h>
#include <pthread.h>
#include "constants.h"
#include "logger.h"
#include "brakes.c"
#include "button.c"
#include "ant.c"
#include "gps.c"

extern char filename[256];
extern int currentPwmSignal;
extern int currentBrakeActivation;

int setup(){
    logToConsole("SETUP STARTED");
    
    

    //pthread_mutex_init(&brakeMutex, NULL);
    //pthread_mutex_init(&pwmMutex, NULL);
    //pthread_mutex_init(&limitMutex, NULL);
    //pthread_mutex_init(&gpsMutex, NULL);
    //pthread_mutex_init(&antMutex, NULL);
    
    
    sprintf(filename, "/home/pi/AMT/log/log_%d.txt", (int)time(NULL));
    currentPwmSignal = PWM_MINIMUM;
    currentBrakeActivation = 0;
    
    // Setting up wiringPi
    if(wiringPiSetup() == -1){
        logToConsole("Error setting up wiringPi\n");
        return 1;
    }
    
    // Setting up pins
    if(softPwmCreate(GPIO_PWM,0,PWM_RANGE) != 0){
        logToConsole("Error while softPwmCreate\n");
        return 2;
    }
    
    pinMode(GPIO_BUTTON, INPUT);
    pinMode(GPIO_BRAKE1, INPUT);
    #ifdef BRAKE2
        pinMode(GPIO_BRAKE2, INPUT);
    #endif
    return createThreads();
}

int createThreads(){
    pthread_t brakeThread, buttonThread, hallThread, gpsThread;
    int res = 0;

	// Create Brake Thread
	res = piThreadCreate(brake);
	if(res != 0){
	    logToConsole("Brake Thread Create Error");
		return res;
	}
	logToConsole("Brake Thread Created");
	
	// Create Button Thread
	res = piThreadCreate(button);
	if(res != 0){
	    logToConsole("Button Thread Create Error");
		return res;
	}
	logToConsole("Button Thread Created");

    
    // Create Ant Thread
	res = piThreadCreate(ant);
	if(res != 0){
	    logToConsole("Ant Thread Create Error");
		return res;
	}
	logToConsole("Ant Thread Created");
    /*
	// Create GPS Thread
	res = piThreadCreate(gps);
	if(res != 0){
	    logToConsole("GPS Thread Create Error");
		return res;
	}
	logToConsole("GPS Thread Created");
    */
	return res;
}
