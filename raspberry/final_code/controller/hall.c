#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include "logger.h"
#include "constants.h"
#include <unistd.h>
#include <string.h>

char logMessage[256];
unsigned int _lastPeak;
float _current_speed = 0;

int createSockFd(int portno){
	int sockfd;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0){
        error("ERROR opening socket");
	}
    server = gethostbyname("localhost");
    memset((char *) &serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0){ 
        error("ERROR connecting");
	}

	return sockfd;
}

void *hallThreadPtr(void *arg){
    logToConsole("Hall Thread started"); 
	int sockfd, n;   
    char buffer[256], tmp[256], *ptr;
    int t=0, rpm;
    sockfd = createSockFd(2301);
	memset(buffer, 0, 256);
    while(1){
        memset(buffer,0,256);
        memset(tmp,0,sizeof(buffer));
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0) 
            logToConsole("ERROR reading from socket");
        if(n>0){
            sprintf(logMessage, "Received ATN+ message: %s",buffer);
            logToConsole(logMessage);
			/*  Verarbeitung der Daten  */
			// Searches for 'RPM=' in output
			if(strstr(buffer, "RPM=")){
			    ptr = strstr(buffer, "RPM=");
			    // Remove leading "RPM='"        
			    ptr=ptr+sizeof(*ptr)*5;
			    t = strcspn(ptr, "'");
			    // Remove trailing "'"    
			    strncpy(tmp, ptr, t); 
			    // Char to Integer        
			    rpm = atoi(tmp);
			    // Compute speed out of rpm and wheel length in km/h
			    _current_speed = rpm * WHEEL_LENGTH * 0.06;
			    _lastPeak = micros();
			    sprintf(logMessage, "rpm: %d", rpm);
			    logToConsole(logMessage);
			    sprintf(logMessage, "velocity: %.2f", _current_speed);
			    logToConsole(logMessage);
			} else{
			    logToConsole("String did not contain RPM");
			}
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    	
    logToConsole("ANT+ Thread Ended"); 
}

