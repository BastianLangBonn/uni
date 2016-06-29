#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include "logger.c"
#include "constants.c"

void readHallSensor(){
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
            logToConsole("Received ATN+ message: %s\n",buffer);
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
			    logToConsole("rpm: %d", rpm);
			    logToConsole("velocity: %.2f", _current_speed);
			} else{
			    logToConsole("String did not contain RPM\n");
			}
        }
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
    }
    	
    logToConsole("ANT+ Thread Ended\n"); 
}

