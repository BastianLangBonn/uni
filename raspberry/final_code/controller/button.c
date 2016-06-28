#include <stdio.h>
#include "constants.c"

int readButton(int pwmSignal){
    if(digitalRead(GPIO_BUTTON) == 1){
        pwmSignal++;
        if(pwmSignal > PWM_MAXIMUM){ 
            pwmSignal = PWM_MINIMUM;
        }
	    delay(200); //Delay needed for button press
	}
    return pwmSignal;
}
