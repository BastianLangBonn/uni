#include <stdio.h> 

void writeToFile(char* text, char filename[256]){
    /* Open file to append, create if not existent*/
    FILE *f = fopen(filename, "a");
    if (f == NULL){
        FILE *f = fopen(filename, "w");
        if(f == NULL){
            printf("Error opening file: %s!\n", filename);
            return;
        }
    }

    /* print text */
    fprintf(f, "%s\n", text);

    fclose(f);
}
