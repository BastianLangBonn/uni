#include <stdio.h>

#include "setup.c"
#include "logger.h"
#include "constants.h"

int main(){
    char logMessage[256];    

    int result = setup();
    if(result != 0){
        sprintf(logMessage, "timestamp: %d, Error during setup: %d", micros(), result);
        logToConsole(logMessage);
        return result;
    }    
    
    while(1){ 
        delay(LOGGING_UPDATE);
    }    
}
