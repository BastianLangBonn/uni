/* Method that sets up all needed pins */
#include <wiringPi.h>
#include <softPwm.h>
#include "constants.c"

int setup(){
    #ifdef DEBUG
        printf("SETUP STARTED\n");
    #endif
    
    // Setting up wiringPi
    if(wiringPiSetup() == -1){
        #ifdef DEBUG
            printf("Error setting up wiringPi\n");
        #endif
        return 1;
    }
    
    // Setting up pins
    if(softPwmCreate(GPIO_PWM,0,PWM_RANGE) != 0){
        #ifdef DEBUG
            printf("Error while softPwmCreate\n");
        #endif
        return 2;
    }
    
    pinMode(GPIO_BUTTON, INPUT);
    pinMode(GPIO_BRAKE1, INPUT);
    #ifdef BRAKE2
        pinMode(GPIO_BRAKE2, INPUT);
    #endif
    return 0;
}
