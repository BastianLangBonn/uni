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
    int sockfd, portno = 8168, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    
    char buffer[256], tmp[256], *ptr;
    int t=0, rpm;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname("localhost");
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    
    bzero(buffer,256);
    strcpy(buffer, "X-set-channel: 0s" );
    
    n = write(sockfd,buffer,strlen(buffer));
    if (n < 0) 
         error("ERROR writing to socket");
    
    while(1){
        bzero(buffer,256);
        bzero(tmp,256);
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0) 
            error("ERROR reading from socket");
        if(n>0){
            printf("%s",buffer);
            
            /*  Verarbeitung der Daten  */
            ptr = strstr(buffer, "RPM=");   //Sucht in der Ausgabe nach 'RPM='
            // ^RPM='366.00' />
            printf("%s", ptr);
            
            //ptr = strstr(ptr, "'");
            ptr=ptr+sizeof(*ptr)*5;
            printf("%s", ptr);
            t = strcspn(ptr, "'");
            
            strncpy(tmp, ptr, t);
            
            printf("%s\n", tmp);
            
            rpm = atoi(tmp);
            
            printf("%d\n", rpm);
        }
    }
    
    return 0;
}
