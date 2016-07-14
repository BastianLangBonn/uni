#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#include "logger.h"
#include "constants.h"
#include "motor.h"

char logMessage[256];
extern double currentVelocity;
extern double currentPower;
extern double currentTorque;
extern int withinLimit; 
char *ptr;

void handleRpmMessage(char buffer[256]){
    int rpm, t;
    char tmp[256];
    memset(tmp,0,sizeof(buffer));
    ptr = strstr(buffer, "RPM=");
    // Remove leading "RPM='"        
    ptr=ptr+sizeof(*ptr)*5;
    t = strcspn(ptr, "'");
    // Remove trailing "'"    
    strncpy(tmp, ptr, t); 
    // Char to Integer        
    rpm = atoi(tmp);
    // Compute speed out of rpm and wheel length in km/h
    pthread_mutex_lock(&velocityMutex);
    currentVelocity = rpm * WHEEL_LENGTH * 0.06;
    sprintf(logMessage, "rpm: %d", rpm);
    logToConsole(logMessage);
    sprintf(logMessage, "velocity: %.2lf", currentVelocity);
    logToConsole(logMessage);
    if(currentVelocity > MAX_TEMPO && withinLimit == 1){
        withinLimit = 0;
        notifyLimitReached();
    } else if(currentVelocity < MAX_TEMPO && withinLimit == 0){
        withinLimit = 1;
        notifyLimitLeft();
    }
    pthread_mutex_unlock(&velocityMutex);
}

void handleTorqueMessage(char buffer[256]){
    logToConsole("Handling Torque Message");
    int rpm, t;
    char tmp[256];
    memset(tmp,0,sizeof(buffer));
    ptr = strstr(buffer, "Nm=");
    // Remove leading "Nm='" -> factor 4        
    ptr=ptr+sizeof(*ptr)*4;
    t = strcspn(ptr, "'");
    // Remove trailing "'"    
    strncpy(tmp, ptr, t); 
    // Char to Integer        
    currentTorque = atof(tmp);
    sprintf(logMessage, "torque: %.2lfNm", currentTorque);
    logToConsole(logMessage);
}

void handlePowerMessage(char buffer[256]){
    int t;
    char tmp[256];
    memset(tmp,0,sizeof(buffer));
    ptr = strstr(buffer, "watts=");
    // Remove leading "watts='"  -> factor 7       
    ptr=ptr+sizeof(*ptr)*7;
    t = strcspn(ptr, "'");
    // Remove trailing "'"    
    strncpy(tmp, ptr, t); 
    // Char to Integer        
    currentPower = atof(tmp);
    sprintf(logMessage, "power: %.2lfwatts", currentPower);
    logToConsole(logMessage);
}

void *hallThreadPtr(void *arg){
    logToConsole("Hall Thread started"); 
	int sockfd, n;   
    char buffer[256];
    int t=0, rpm;
    sockfd = createSockFd(2301);
	memset(buffer, 0, 256);
    while(1){
        memset(buffer,0,256);
        
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0) 
            logToConsole("ERROR reading from socket");
        if(n>0){
            sprintf(logMessage, "Received ANT+ message: %s",buffer);
            logToConsole(logMessage);
			if(strstr(buffer, "RPM=")){
			    logToConsole("Speed message received");
			    handleRpmMessage(buffer);
			} else if(strstr(buffer, "Torque")){
			    logToConsole("Torque message received");
			    handleTorqueMessage(buffer);
			} else if(strstr(buffer, "watts=")){ 
			    logToConsole("Power message received");
			    handlePowerMessage(buffer);
			}else{
			    logToConsole("String did not contain any relevant information");
			}
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    	
    logToConsole("ANT+ Thread Ended"); 
}



