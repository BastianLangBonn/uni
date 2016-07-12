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
    char *latitude, *longitude, *altitude;       
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
            latitude = strtok(NULL, ";");
            longitude = strtok(NULL, ";");
            altitude = strtok(NULL, ";");
            
            latitude = strtok(latitude, "=");
            latitude = strtok(NULL, "=");
            currentLatitude = atof(latitude);
            
            longitude = strtok(longitude, "=");
            longitude = strtok(NULL, "=");
            currentLongitude = atof(longitude);
            
            altitude = strtok(altitude, "=");
            altitude = strtok(NULL, "=");
            currentAltitude = atof(altitude);
            
            sprintf(logMessage,"GPS THREAD: extracted position:%.2fN;%.2fE;height:%.2f", currentLatitude, currentLongitude, currentAltitude);
            logToConsole(logMessage); 
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    logToConsole("GPS thread terminated"); 
}