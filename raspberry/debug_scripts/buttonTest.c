#include <wiringPi.h>
#include <stdio.h>

/* GPIO Settings */
#define GPIO_BUTTON 0

int main(){
    if (wiringPiSetup()==-1){
        printf("Setup failed\n");
        return 1;
    }
    printf("Setup done\n");
    pinMode(GPIO_BUTTON, INPUT);
    
    while(1){
        if(digitalRead(GPIO_BUTTON) == 1){
            printf("Button Pressed\n");
            delay(200);
        }
    }
    
    
}
