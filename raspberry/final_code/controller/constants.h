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
#define SENSOR_UPDATE   20

/* VEHICLE CONSTANTS */
#define WHEEL_LENGTH    1.445 // in m
#define MAX_TEMPO       25 // Maximum velocity in km/h

/* DELAY VALUES */
#define SENSOR_UPDATE   20
#define SPEED_UPDATE    20
#define LOGGING_UPDATE  100

/* MISC */
#define BUFMAX          100

int currentBrakeActivation;
int currentPwmSignal;
int withinLimit;
double currentVelocity;
double currentLatitude;
double currentLongitude;
double currentAltitude;
double currentTorque;
double currentPower;

/* Mutexes */
pthread_mutex_t brakeMutex;
pthread_mutex_t pwmMutex;
pthread_mutex_t limitMutex;
pthread_mutex_t gpsMutex;
pthread_mutex_t antMutex;

char filename[256];
