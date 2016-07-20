#include <pthread.h>
/* GPIO SETUP */
#define GPIO_PWM    8
#define GPIO_BUTTON 0
#define GPIO_BRAKE1  1

// #define BRAKE2 //When defined a second brake sensor has to be plugged in
#ifdef BRAKE2
    #define GPIO_BRAKE2
#endif

#define DEBUG
#define PWM_MINIMUM     7
#define PWM_MAXIMUM     19
#define PWM_RANGE       20

/* VEHICLE CONSTANTS */
#define WHEEL_LENGTH    1.445 // in m
#define MAX_TEMPO       25 // Maximum velocity in km/h

/* DELAY VALUES */
#define SENSOR_UPDATE   100
#define SPEED_UPDATE    20
#define LOGGING_UPDATE  100

/* MISC */
#define BUFMAX          100

char dataLog[256], debugLog[256];
int currentPwmSignal;
double currentVelocity, currentPower, currentTorque;
