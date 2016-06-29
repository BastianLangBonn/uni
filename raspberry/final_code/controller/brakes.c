#include <stdio.h>
#include "constants.c"


/**
* Reads the GPIO-PINs and returns if at least one of them indicates an 
* activated brake.
*/
int readBrakeSensors(){

    if(digitalRead(GPIO_BRAKE1) == 0){
        return 1;
    }
    
    #ifdef BRAKE2	
        if(digitalRead(GPIO_BRAKE2) == 0){
            return 1;
        }   
    #endif
    
    return 0;    
}
