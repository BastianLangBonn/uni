#include <wiringPi.h>
#include <stdio.h>

/* GPIO Setup */
#define GPIO_BRAKE  1

int main(){
    if(wiringPiSetup() == -1){
        printf("Setup Failed\n");
        return 1;
    }
    
    pinMode(GPIO_BRAKE, INPUT);
    
    while(1){
        if(digitalRead(GPIO_BRAKE) == 1){
            printf("Brake Activated\n");
        }
        if(digitalRead(GPIO_BRAKE) == 0){
            printf("Brake Deactivated\n");
        }
        delay(1000);
    }
    
    
}