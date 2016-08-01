#include "logger.h"

/**
* Reads the GPIO-PINs and returns if at least one of them indicates an 
* activated brake.
*/
int readBrakeSensors(){

    if(digitalRead(GPIO_BRAKE1) == 0){
        logToConsole("Brake Activated");
        return 1;
    }
    
    #ifdef BRAKE2	
        if(digitalRead(GPIO_BRAKE2) == 0){
            logToConsole("Brake Activated");
            return 1;
        }   
    #endif
    
    //logToConsole("Brake Loose");    
    return 0;    
}
