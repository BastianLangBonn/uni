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

extern double currentLongitude;
extern double currentLatitude;
extern double currentAltitude;

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
            pthread_mutex_lock(&latitudeMutex);
            latitude = strtok(buffer, ";");
            latitude = strtok(NULL, ";");
            longitude = strtok(NULL, ";");
            altitude = strtok(NULL, ";");
            
            latitude = strtok(latitude, "=");
            latitude = strtok(NULL, "=");
            currentLatitude = atof(latitude);
            
            longitude = strtok(longitude, "=");
            longitude = strtok(NULL, "=");
            pthread_mutex_lock(&longitudeMutex);
            currentLongitude = atof(longitude);
            
            altitude = strtok(altitude, "=");
            altitude = strtok(NULL, "=");
            currentAltitude = atof(altitude);
            
            sprintf(logMessage,"GPS THREAD: extracted position:%.4fN;%.4lfE;height:%.2lf", currentLatitude, currentLongitude, currentAltitude);
            pthread_mutex_unlock(&longitudeMutex);
            pthread_mutex_unlock(&latitudeMutex);
            logToConsole(logMessage); 
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    logToConsole("GPS thread terminated"); 
}
