#include "constants.c"
#include "logger.h"

void setMotorSpeed(int speed){
    logToConsole(printf("Setting PWM Signal to %d", speed));
    softPwmWrite(GPIO_PWM, speed);
}
