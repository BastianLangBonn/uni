#include <wiringPi.h>
#include <stdio.h>
#include <lcd.h>

/* GPIO Settings */
#define LCD_D0		    25
#define LCD_D1		    24
#define LCD_D2		    23
#define LCD_D3		    22
#define LCD_D4		    21
#define LCD_D5		    14
#define LCD_D6		    13
#define LCD_D7		    12
#define LCD_RS		    29
#define LCD_STRB        28

/*  Display Settings  */
#define LCD_ROWS            2
#define LCD_COLUMNS         16
#define LCD_BITS            8

int main(){
    int lcdHandler;

    if(wiringPiSetup()==-1){
        printf("Setup Failed\n");
        return 1;
    }
    printf("Setup Done\n");
    unsigned int start = micros();
    lcdHandler = lcdInit(LCD_ROWS, LCD_COLUMNS, LCD_BITS, LCD_RS, LCD_STRB, LCD_D0, LCD_D1, LCD_D2, LCD_D3, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
    unsigned int duration = micros() - start;
    printf("Handler Initialized in %f\n", duration/1000000.0);
    while(1){
        lcdClear(lcdHandler);
        lcdPrintf(lcdHandler, "Foo");
        printf("Foo\n");
        delay(1000);
        lcdClear(lcdHandler);
        lcdPrintf(lcdHandler, "Bar");
        printf("Bar\n");
        delay(1000);
    }
    
    
}
