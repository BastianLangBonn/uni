#include <stdio.h>
#include <string.h>
#include <stdlib.h>



void handleTorqueMessage(char buffer[256] ){
    char tmp[256];
    char *ptr;
    int t;
    float currentTorque;
    ptr = strstr(buffer, "watts=");
    ptr=ptr+sizeof(*ptr)*7;
    t = strcspn(ptr, "'");
    strncpy(tmp, ptr, t); 
    currentTorque = atof(tmp);
    printf("torque: %.2f\n", currentTorque);
    
}

void handleRpmMessage(char buffer[256]){
    char tmp[256];
    int rpm, t;
    char *ptr;
    ptr = strstr(buffer, "RPM=");
    // Remove leading "RPM='"        
    ptr=ptr+sizeof(*ptr)*5;
    t = strcspn(ptr, "'");
    // Remove trailing "'"    
    strncpy(tmp, ptr, t); 
    // Char to Integer        
    rpm = atoi(tmp);
    printf("RPM: %d\n", rpm);
}

int main(){
/*
    char message[] = "<Speed id='51624p' timestamp='12345' RPM='397.22' />";
    handleRpmMessage(message);
*/
    char message[] = "<Power id='51624p' timestamp='12345' watts='0.22' />";
    handleTorqueMessage(message);

}
