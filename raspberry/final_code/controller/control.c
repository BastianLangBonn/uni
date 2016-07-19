#include <stdio.h>

#include "setup.c"
#include "logger.h"
#include "constants.h"
#include "button.c"
#include "brakes.c"
#include "ant.h"
#include "motor.h"

extern int currentPwmSignal;
extern double currentVelocity;

int main(){
    char logMessage[256];
    int isButtonPressed, isBrakeActivated;
    int limitReached = 0;    

    int result = setup();
    if(result != 0){
        sprintf(logMessage, "timestamp: %d, Error during setup: %d", micros(), result);
        logToConsole(logMessage);
        return result;
    }    
    
    while(1){ 
        // Read Button
        isButtonPressed = readButton();
               
        // Read Brakes
        isBrakeActivated = readBrakeSensors();
        
        // Read Ant Sensor
        receiveAntMessage();
        
        // Update PWM Signal
        if(isButtonPressed && !isBrakeActivated){
            if(currentPwmSignal < PWM_MAXIMUM){
                currentPwmSignal++;
            }
        }
        
        if(isBrakeActivated){
            if(currentPwmSignal > PWM_MINIMUM){
                decelerate();
                currentPwmSignal = PWM_MINIMUM;
            }
        }
        
        if(currentVelocity > MAX_TEMPO && !limitReached){
            limitReached = 1;
            decelerate();
        } else if (currentVelocity <= MAX_TEMPO && limitReached){
            limitReached = 0;
            setSpeed(currentPwmSignal);
        } else if(!limitReached){
            setSpeed(currentPwmSignal);
        }
        
        // Log Data timestamp, brakes, pwmSignal, velocity, power, torque
        sprintf(logMessage, "%d, %d, %d, %.2lf, %.2lf, %.2lf", (int)time(NULL), isBrakeActivated, currentPwmSignal, currentVelocity, currentPower, currentTorque);
        
        delay(SENSOR_UPDATE);
    }    
}
