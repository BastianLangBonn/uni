#include <stdio.h>
#include <string.h>


// GPGGA,134436.000,0000.0000,N,00000.0000,E,0,00,0.0,0.0,M,0.0,M,,0000*6A
// Received message: time:13:57:29;latitude:0.0;longitude:0.0
char string[] = "time=13:57:29;latitude=0.0;longitude=0.0";
char delimiter[] = ";";
char *ptr, *time, *latitude, *longitude;

int main(){
//initialisieren und ersten Abschnitt erstellen
    time = strtok(string, delimiter);
    latitude = strtok(NULL, delimiter);
    longitude = strtok(NULL, delimiter);


    time = strtok(time,"=");
    time = strtok(NULL, "=");
    printf("Time:%s\n", time);


    latitude = strtok(latitude, "=");
    latitude = strtok(NULL, "=");
    printf("Latitude:%s\n",latitude);


    longitude = strtok(longitude, "=");
    longitude = strtok(NULL, "=");
    printf("Longitude:%s\n", longitude);
}
