#include <stdio.h> 
#include "constants.h"
#include "logger.h"


void logToFile(char* filename, char* text){
    //return;
    /* Open file to append, create if not existent*/
    //printf("filename: %s\n", filename);
    FILE *f = fopen(filename, "a");
    if (f == NULL){
        FILE *f = fopen(filename, "w");
        if(f == NULL){
            printf("Error opening file: %s!\n", filename);
            return;
        }
    }

    
    
    if(f != NULL){
        /* print text */
        fprintf(f, "%s\n", text);
        fclose(f);
    }
}

void logToConsole(char* text){
    #ifdef DEBUG
	    printf("%s\n", text);
	#endif
	//char logMessage[256];
	//sprintf(logMessage, "timestamp: %d, message: %s", (int)time(NULL), text);
	//logToFile(debugLog, logMessage);
}
