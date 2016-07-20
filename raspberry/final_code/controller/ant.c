#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "logger.h"
#include "constants.h"
#include "motor.h"
#include "socket.c"

char logMessage[256];
extern double currentVelocity;
extern double currentPower;
extern double currentTorque;
int isWithinLimit; 
char *ptr;
int lastPeak;

void handleRpmMessage(char buffer[256]){
    int rpm, t;
    char tmp[256];
    lastPeak = millis();
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
    sprintf(logMessage, "rpm: %d", rpm);
    //logToConsole(logMessage);
    currentVelocity = rpm * WHEEL_LENGTH * 0.06;    
    sprintf(logMessage, "timestamp: %d, velocity: %.2lf",(int)time(NULL), currentVelocity);
    logToFile(antLog, logMessage);
}

void handleTorqueMessage(char buffer[256]){
    //logToConsole("Handling Torque Message");
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
    sprintf(logMessage, "timestamp: %d, torque: %.2lfNm", (int)time(NULL), currentTorque);
    logToFile(antLog, logMessage);
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
    sprintf(logMessage, "timestamp: %d, power: %.2lfwatts", (int)time(NULL), currentPower);
    logToFile(antLog, logMessage);
}

void handleSensorDrop(char buffer[256]){
    if(strstr(buffer, "type='Speed'")){
        //logToConsole("Speed Dropped");
        currentVelocity = 0.0;
    } else if(strstr(buffer, "type='Power'")){
        //logToConsole("Power Dropped");
        currentTorque = 0.0;
        currentPower = 0.0;
    } else{
        //logToConsole("Not important sensor dropped");
    }
}

void *antThreadPtr(void *arg){
    //logToConsole("ANT Thread started"); 
	int sockfd, n;   
    char buffer[256];
    int t=0, rpm;
    int currentPeak;
    lastPeak = millis();
    sockfd = createSockFd(2301);
	memset(buffer, 0, 256);
    while(1){
        currentPeak = millis();
        if(currentPeak - lastPeak > 2000){
            //logToConsole("Speed Timed Out");
            currentVelocity = 0.0;
        }
        memset(buffer,0,256);
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0) 
            //logToConsole("ERROR reading from ANT socket");
        if(n>0){
            sprintf(logMessage, "Received ANT+ message: %s",buffer);
            //logToConsole(logMessage);
			if(strstr(buffer, "<Speed")){
			    //logToConsole("Speed message received");
			    handleRpmMessage(buffer);
			} else if(strstr(buffer, "<Torque")){
			    //logToConsole("Torque message received");
			    handleTorqueMessage(buffer);
			} else if(strstr(buffer, "<Power")){ 
			    //logToConsole("Power message received");
			    handlePowerMessage(buffer);
			} else if(strstr(buffer, "<SensorDrop")){
			    //logToConsole("Sensor dropped");
			    handleSensorDrop(buffer);
			} else{
			    //logToConsole("String did not contain any relevant information");
			}
        }
		delay(SPEED_UPDATE); //Verhindert busy-waiting
    }    	
    //logToConsole("ANT+ Thread Ended"); 
}

