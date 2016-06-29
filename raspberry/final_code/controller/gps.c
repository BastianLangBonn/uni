#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <unistd.h>
#include <string.h>

#include "logger.h"
#include "constants.h"
#include "socket.c"

void *gpsThreadPtr(void *arg){
        
    #ifdef DEBUG
        printf("GPS thread started\n"); 
    #endif
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
            error("ERROR reading from socket");
		}
        if(n>0){
            printf("Received GPS message: %s\n", buffer);
                            
            // Get data out of message
            latitude = strtok(buffer, ";");
            latitude = strtok(NULL, ";");
            longitude = strtok(NULL, ";");
            
            latitude = strtok(latitude, "=");
            latitude = strtok(NULL, "=");
            currentLatitude = atof(latitude);
            
            longitude = strtok(longitude, "=");
            longitude = strtok(NULL, "=");
            currentLongitude = atof(longitude);
            #ifdef DEBUG
                printf("GPS THREAD: extracted position:%.2fN;%.2fE\n", currentLatitude, currentLongitude); 
            #endif
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    #ifdef DEBUG
        printf("GPS thread terminated\n"); 
    #endif
}
