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
        printf(logMessage);
        logToConsole(logMessage);
        return result;
    }    
    
    while(1){ 
        // Read Button
        logToConsole("Reading Button");
        isButtonPressed = readButton();
               
        // Read Brakes
        logToConsole("Reading Brakes");
        isBrakeActivated = readBrakeSensors();
        
        // Read Ant Sensor
        logToConsole("Reading Ant Message");
        //receiveAntMessage();
        
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
        
        logToConsole("Sending motor command");
        if(currentVelocity > MAX_TEMPO && !limitReached){
            limitReached = 1;
            decelerate();
        } else if (currentVelocity <= MAX_TEMPO && limitReached){
            limitReached = 0;
            setSpeed(currentPwmSignal);
        } else if(!limitReached){
            setSpeed(currentPwmSignal);
        }
        
        logToConsole("Logging Data");
        // Log Data timestamp, brakes, pwmSignal, velocity, power, torque
        sprintf(logMessage, "%d, %d, %d, %.2lf, %.2lf, %.2lf", (int)time(NULL), isBrakeActivated, currentPwmSignal, currentVelocity, currentPower, currentTorque);
        logToFile(dataLog, logMessage);
        
        delay(SENSOR_UPDATE);
    }    
}
