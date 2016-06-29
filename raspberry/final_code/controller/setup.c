/* Method that sets up all needed pins */
#include <wiringPi.h>
#include <softPwm.h>
#include "constants.h"
#include "logger.h"

int setup(){
    logToConsole("SETUP STARTED");
    
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
    return 0;
}
