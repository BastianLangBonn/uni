#include <wiringPi.h>
#include <stdio.h>
#include <softPwm.h>

/* GPIO Setup */
#define GPIO_PWM    8

#define PWM_RANGE           200
float current_value = 0.2;


int main(int activation){

    /*
    int bright ;

	printf ("Raspberry Pi wiringPi PWM test program\n") ;

	if (wiringPiSetup () == -1)
	return 1;


    
	pinMode (8, PWM_OUTPUT) ;

	for (;;)
	{
	for (bright = 0 ; bright < 1024 ; ++bright)
	{
		pwmWrite (8, bright) ;
		printf("Send %d\n", bright);
		delay (20) ;
	}

	for (bright = 1023 ; bright >= 0 ; --bright)
	{
		pwmWrite (8, bright) ;		
		printf("Send %d\n", bright);
		delay (20) ;
	}
	printf("loop done\n");
	}

	return 0 ;
	*/
    
    
    if (wiringPiSetup () == -1)
	    return 1;
    
    if(softPwmCreate(GPIO_PWM, 0, PWM_RANGE) == -1){
        printf("PWM CREATE FAILED\n");
        return 2;
    }
    
    printf("Setup Done\n");
    
    
    
    softPwmWrite(GPIO_PWM, activation);//(int)(PWM_RANGE * activation));    
    printf("Send Signal\n");
    while(1){
       // NOOP
    }
    
}
