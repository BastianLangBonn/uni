/*
 Quelle: http://www.linuxhowtos.org/C_C++/socket.htm
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 

void error(char *msg){
  perror(msg);
  exit(0);
}

int main(){
    int sockfd, portno = 2301, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    
    char buffer[256], tmp[256], *ptr;
    int t=0, rpm;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname("localhost");
    memset((char *) &serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    
    memset(buffer, 0, 256);
    // strcpy(buffer, "X-set-channel: 0s" );
    
    //n = write(sockfd,buffer,strlen(buffer));
    if (n < 0) 
         error("ERROR writing to socket");
    
    while(1){
	    //printf("Beginning of loop\n");
        memset(buffer,0,256);
	    //printf("bzeroed buffer\n");
        memset(tmp,0,sizeof(buffer));
	    //printf("bzeroed tmp\n");
        ptr = NULL;
	    printf("Trying to read socket\n");
        n = read(sockfd,buffer,255);
        if (n < 0) 
            error("ERROR reading from socket");
        if(n>0){
            printf("Received message: %s\n",buffer);
        }
        //printf("End of loop\n");
    }
    //printf("Dropped out of loop...\n");
    
    return 0;
}
