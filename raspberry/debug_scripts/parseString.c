#include <stdio.h>
#include <string.h>
#include <stdlib.h>


void handleTorqueMessage(char buffer[256] ){
    char tmp[256];
    char *ptr;
    int t;
    float currentTorque;
    ptr = strstr(buffer, "Nm=");
    printf("Ptr: %s\n", ptr);
    ptr=ptr+sizeof(*ptr)*4;
    printf("Ptr: %s\n", ptr);
    t = strcspn(ptr, "'");
    printf("t: %d\n", t);
    strncpy(tmp, ptr, t);
    printf("tmp: %s\n", tmp); 
    currentTorque = atof(tmp);
    printf("torque: %.2f\nnM", currentTorque);
    
}

void handlePowerMessage(char buffer[256] ){
    char tmp[256];
    char *ptr;
    int t;
    float currentPower;
    ptr = strstr(buffer, "watts=");
    ptr=ptr+sizeof(*ptr)*7;
    t = strcspn(ptr, "'");
    strncpy(tmp, ptr, t); 
    currentPower = atof(tmp);
    printf("power: %.2f\nwatts", currentPower);
    
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

    char message[] = "<Power id='51624p' timestamp='12345' watts='0.22' />";
    handleTorqueMessage(message);
    */
    
    char message[] = "<Torque id='51624p' timestamp='12345' Nm='299.22' />";
    handleTorqueMessage(message);

}
