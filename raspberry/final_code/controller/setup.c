/* Method that sets up all needed pins */
#include <wiringPi.h>
#include <softPwm.h>
#include <pthread.h>
#include "constants.h"
#include "logger.h"
#include "sensors.c"
#include "hall.c"

extern char debugLog[256], pwmLog[256], sensorLog[256];

int setup(){
    char logMessage[256];
    logToConsole("SETUP STARTED");
    int currentTime = (int)time(NULL);
    sprintf(pwmLog, "/home/pi/AMT/log/%d_pwm.txt", currentTime);
    sprintf(debugLog, "/home/pi/AMT/log/%d_debug.txt", currentTime);
    sprintf(sensorLog, "/home/pi/AMT/log/%d_sensor.txt", currentTime);
    sprintf(speedLog, "/home/pi/AMT/log/%d_speed.txt", currentTime);
    
    // Write Headers
    sprintf(logMessage, "timestamp, velocity");
    logToFile(speedLog, logMessage);
        
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
    
    initializeMotor();
    
    return createThreads();
}

int createThreads(){
    pthread_t sensorThread, buttonThread, hallThread; 
    int res = 0;

	// Create Sensor Thread
	res = pthread_create(&sensorThread, NULL, sensorThreadPtr, NULL);
	if(res != 0){
	    logToConsole("Sensor Thread Create Error");
		return res;
	}
	logToConsole("Sensor Thread Created");
	


    // Create Hall Thread
	res = pthread_create(&hallThread, NULL, hallThreadPtr, NULL);
	if(res != 0){
	    logToConsole("Hall Thread Create Error");
		return res;
	}
	logToConsole("Hall Thread Created");

    
	return res;
}
