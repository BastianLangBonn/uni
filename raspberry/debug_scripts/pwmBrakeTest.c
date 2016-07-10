#include <wiringPi.h>
#include <stdio.h>
#include <softPwm.h>

/* GPIO Setup */
#define GPIO_BUTTON 0
#define GPIO_PWM    8

#define PWM_MIN     5
#define PWM_RANGE   20


void decelerate(){
    softPwmWrite(GPIO_PWM, 8);
    delay(10); // wiringPi Update rate ~100Hz (when range is 100...)
}

int main(void){    
    
    if (wiringPiSetup () == -1)
	    return 1;
    
    if(softPwmCreate(GPIO_PWM, 0, PWM_RANGE) == -1){
        printf("PWM CREATE FAILED\n");
        return 2;
    }
    
    pinMode(GPIO_BUTTON, INPUT);
    
    printf("Setup Done\n");
    
    int activation = PWM_MIN;
    while(1){
        if(digitalRead(GPIO_BUTTON) == 1){
            activation = activation + 1;
            if(activation > PWM_RANGE){
                decelerate();
                activation = PWM_MIN;
            }
            softPwmWrite(GPIO_PWM, activation);
            printf("Set activation to %d\n", activation);
            delay(200);
        }
    }    
}
