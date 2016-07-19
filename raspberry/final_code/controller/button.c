#include <stdio.h>
#include "logger.h"

int readButton(){
    if(digitalRead(GPIO_BUTTON) == 1){
        logToConsole("Button Pressed");
	    delay(200); //Delay needed for button press
	    return 1;
	}
	return 0;
}
