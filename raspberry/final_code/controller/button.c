#include <stdio.h>
#include "constants.c"

int readButton(){

    /*  Motor an- und ausschalten  */
	if(digitalRead(GPIO_MOTOR_SWITCH)){
        _motor_on++;
        if(_motor_on > 10){ 
            _motor_on = 0;
            #ifdef DEBUG
		        printf("Motor turned off\n");
		    #endif
        }
    _current_activation = _motor_on * 0.1;
    #ifdef DEBUG
	    printf("Motor activation set to %.2f.\n", _current_activation);
	#endif
	delay(200); //Notwendig wegen springen des Schalters 
	
}
