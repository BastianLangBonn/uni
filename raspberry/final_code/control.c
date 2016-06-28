#include <wiringPi.h>
#include <softPwm.h>
#include <stdio.h>
#include <pthread.h>


#define DEBUG
// #define BRAKE2 //When defined a second brake sensor has to be plugged in

/* GPIO SETUP */
#define GPIO_PWM    8
#define GPIO_BUTTON 0
#define GPIO_BRAKE  1
#ifdef BRAKE2
    #define GPIO_BRAKE2
#endif


/* VEHICLE CONSTANTS */
#define WHEEL_LENGTH    1.445 // in m
#define MAX_TEMPO       25 // Maximum velocity in km/h


/* DELAY VALUES */
#define SENSOR_UPDATE   20
#define SPEED_UPDATE    20
#define LOGGING_UPDATE  100

/* MISC */
#define BUFMAX          100

/* VARIABLES */

/*********/
/* SETUP */
/*********/
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
    pinMode(GPIO_BRAKE, INPUT);
    #ifdef BRAKE2
        pinMode(GPIO_BRAKE2, INPUT);
    #endif
    return 0;
}


int main(){
    result = setup();
    if(result != 0){
        #ifdef DEBUG
            printf("Error during setup\n");
        #endif
        return result;
    }
    
    
}
