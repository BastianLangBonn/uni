#include <stdio.h>
#include "constants.c"
#include "motor.c"

/**
* Gets the current status and the read on the brakes.
* Returns the new brake status.
* brakeRead: 0 if no brake has been activated, 1 otherwise
* brakeActivation: 0 if no brake has been active so far, 1 otherwise
* There is only need for action if both values differ.
**/
int getNewActivation(int brakeRead, int brakeActivation){
    
    if(brakeRead == 0 && brakeActivation == 1){
        return 0;
    }
    
    if(brakeRead == 1 && brakeActivation == 0){
        return 1;
    }
    
    return brakeRead;
}

/**
* Reads the GPIO-PINs and returns if at least one of them indicates an 
* activated brake.
*/
int isBrakeActivated(){

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

int checkBrakes(int currentBrakeActivation, int speed){
    int brakeRead = isBrakeActivated();
    int newActivation = getNewActivation(brakeRead, currentBrakeActivation);
    
    if(newActivation != currentBrakeActivation){
        #ifdef DEBUG
            printf("Brake Status has changed. Sending new Motor Command\n");
        #endif
        currentBrakeActivation = newActivation;
        setMotorSpeed(currentBrakeActivation * speed);
    }
    return currentBrakeActivation;
}


