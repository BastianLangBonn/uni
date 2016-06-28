/* GPIO SETUP */
#define GPIO_PWM    8
#define GPIO_BUTTON 0
#define GPIO_BRAKE1  1

// #define BRAKE2 //When defined a second brake sensor has to be plugged in
#ifdef BRAKE2
    #define GPIO_BRAKE2
#endif

#define DEBUG
#define PWM_RANGE   20
