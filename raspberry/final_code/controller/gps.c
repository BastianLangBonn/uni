#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <unistd.h>
#include <string.h>
#include <stdio.h>

#include <stdlib.h>

#include "logger.h"
#include "constants.h"
#include "socket.c"

extern float currentLongitude;
extern float currentLatitude;
extern float currentAltitude;

void *gpsThreadPtr(void *arg){
    logToConsole("GPS thread started"); 
        
    char logMessage[256];
    int sockfd, n;
    char *latitude, *longitude;        
    char buffer[256], tmp[256], *ptr;    
        
    memset(buffer, 0, 256);
	sockfd = createSockFd(2300);
    while(1){
        memset(buffer,0,256);
        memset(tmp,0,sizeof(buffer));
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0){
            logToConsole("ERROR reading from socket");
		}
        if(n>0){
            sprintf(logMessage, "Received GPS message: %s", buffer);
            logToConsole(logMessage);
                            
            // Get data out of message
            latitude = strtok(buffer, ";");
            sprintf(logMessage,"latitude: %.2f", latitude);
            logToConsole(logMessage);
            latitude = strtok(NULL, ";");
            sprintf(logMessage,"latitude: %.2f", latitude);
            logToConsole(logMessage);
            longitude = strtok(NULL, ";");
            sprintf(logMessage,"longitude: %.2f", longitude);
            logToConsole(logMessage);
            
            latitude = strtok(latitude, "=");
            latitude = strtok(NULL, "=");
            currentLatitude = atof(latitude);
            sprintf(logMessage,"latitude: %.2f", latitude);
            logToConsole(logMessage);
            
            longitude = strtok(longitude, "=");
            longitude = strtok(NULL, "=");
            currentLongitude = atof(longitude);
            sprintf(logMessage,"GPS THREAD: extracted position:%.2fN;%.2fE", currentLatitude, currentLongitude);
            logToConsole(logMessage); 
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    logToConsole("GPS thread terminated"); 
}
