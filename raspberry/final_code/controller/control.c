//#include <wiringPi.h>
//#include <softPwm.h>
#include <stdio.h>
#include <pthread.h>

#include "setup.c"
#include "brakes.c"

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



int main(){
    int result = setup();
    if(result != 0){
        #ifdef DEBUG
            printf("Error during setup\n");
        #endif
        return result;
    }

    
    
}
