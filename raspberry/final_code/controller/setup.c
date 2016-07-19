/* Method that sets up all needed pins */
#include <wiringPi.h>
#include <softPwm.h>
#include "constants.h"
#include "logger.h"
#include "ant.h"
#include "motor.h"


extern char debugLog[256], dataLog[256];
extern int currentPwmSignal;
extern double currentVelocity, currentPower, currentTorque;

int setup(){
    char logMessage[256];
    //logToConsole("SETUP STARTED");
    int currentTime = (int)time(NULL);
    sprintf(dataLog, "/home/pi/AMT/log/%d_data.txt", currentTime);
    sprintf(debugLog, "/home/pi/AMT/log/%d_debug.txt", currentTime);
    
    // Global Variable Initialization 
    currentPwmSignal = PWM_MINIMUM;
    currentVelocity = 0.0;
    currentPower = 0.0;
    currentTorque = 0.0;
    
    // Write Headers
    sprintf(logMessage, "timestamp, brakes, pwmSignal, velocity, power, torque");
    logToFile(dataLog, logMessage);
        
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
    
    initializeAntConnection();
    initializeMotor();
    
    return 0;
}
