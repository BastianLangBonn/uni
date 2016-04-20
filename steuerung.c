#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h> 
#include <lcd.h> 
#include <pthread.h>
#include <unistd.h>
#include <string.h>


#define DEBUG       //Wenn definiert gibt das Programm in der Konsole Debug-Informationen aus

//#define BRAKE2    //Wenn definiert muss ein zweiter Bremssensor angeschlossen sein

/****************************************************************************************************/
/*  Konstanten										   	    */
/****************************************************************************************************/

/*  GPIO Belegung  */
#define GPIO_PWM            8
#define GPIO_MOTOR_SWITCH   0
#define GPIO_BRAKE1	    1

#ifdef BRAKE2
#define GPIO_BRAKE2         2
#endif

#define GPIO_SPEED          3
#define LCD_D0		    25
#define LCD_D1		    24
#define LCD_D2		    23
#define LCD_D3		    22
#define LCD_D4		    21
#define LCD_D5		    14
#define LCD_D6		    13
#define LCD_D7		    12
#define LCD_RS		    29	// Legt das Speicherregister fest
#define LCD_STRB            28

/*  Display Einstellungen  */
#define LCD_ROWS            2
#define LCD_COLUMNS         16
#define LCD_BITS            8	// Legt fest wie viele Bits verwendet werden
				// Nicht die Anzahl der unterstuetzten Bits

/*  Motorcontroller  */
#define PWM_RANGE           200


/*  Fahrzeug  */
#define WHEEL_LENGTH        1.445   // in m
#define MAX_TEMPO           25      //Legt die maximale Geschwindigkeit in km/h fest

/*  Delay  */
#define DISPLAY_UPDATE      1000
#define SENSOR_UPDATE       20
#define SPEED_UPDATE        20

#define BUFMAX              100



/****************************************************************************************************/
/*  Variablen											    */
/****************************************************************************************************/


int motor_on = 0;			// Legt fest ob der Motor eingeschaltet ist
int brake_on = 0;			// Legt fest ob die Bremse betaetigt wird
int motor_limited = 0;			// Legt das max Tempo für die Motorunterstuetzung fest

float current_activation = 0.2;		// Legt den HIGH Anteil vom PWM-Signal fest
					// 0 <= current_activation <= 1
float current_speed = 0;
int lcd_handler;
char setup_done = 0;

unsigned int now;
unsigned int lastpeak;

/****************************************************************************************************/
/*  Sensor Thread										    */
/****************************************************************************************************/

void *sensor_thread(void *arg){
	while(1){

		/*  Motor an- und ausschalten  */
		if(digitalRead(GPIO_MOTOR_SWITCH)){
			if(motor_on == 0){
				//Motor ist aus und wird angeschaltet
				motor_on = 1;
				#ifdef DEBUG
				printf("Motor angeschaltet\n");
				#endif
			}else{
				//Motor ist an und wird ausgeschaltet
				motor_on = 0;
				#ifdef DEBUG
				printf("Motor ausgeschaltet\n");
				#endif
			}
			delay(200); //Notwendig wegen springen des Schalters 
		}
		
		/*  Bremsen  */
                #ifndef BRAKE2   								
		if(digitalRead(GPIO_BRAKE1) == 0 && brake_on == 0){
			//Bremse neu betaetigt
			brake_on = 1;
			#ifdef DEBUG
			printf("Bremse gezogen\n");
			#endif
		}
                #endif
                
                #ifdef BRAKE2									
                if((digitalRead(GPIO_BRAKE1) == 0 || GPIO_BRAKE2 == 0 ) && brake_on == 0){					//old: &&
                        brake_on = 1;
			#ifdef DEBUG
			printf("Bremse gezogen\n");
			#endif
                }
                #endif
		
		
		#ifndef BRAKE2
		if(digitalRead(GPIO_BRAKE1) == 1 && brake_on == 1){
			//Bremse wieder losgelassen
			brake_on = 0;
			#ifdef DEBUG
			printf("Bremse losgelassen\n");
			#endif
		}
                #endif
                
                #ifdef BRAKE2
		if((digitalRead(GPIO_BRAKE1) == 1 || digitalRead(GPIO_BRAKE2)) == 1 brake_on == 1){	// old:&&
			//Bremse wieder losgelassen
			brake_on = 0;
			#ifdef DEBUG
			printf("Bremse losgelassen\n");
			#endif
		}
                #endif
		
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
	}
}

/****************************************************************************************************/
/*  Display Thread										    */
/****************************************************************************************************/

void *display_thread(void *arg){
	while(1){
		lcdClear(lcd_handler);
		lcdPrintf(lcd_handler, "%d km/h", current_speed);
		lcdPosition(lcd_handler, 0, 1);
		if(motor_on){
			lcdPrintf(lcd_handler, "Motor an");
		}else{
			lcdPrintf(lcd_handler, "Motor aus");
		}
		delay(DISPLAY_UPDATE);
	}
}

/****************************************************************************************************/
/*  Setup											    */
/****************************************************************************************************/

int setup(){
	pthread_t sensor_thr, display_thr;
	
        lastpeak  = micros();

	int res = 0;
	wiringPiSetup();
	res = softPwmCreate(GPIO_PWM, 0, PWM_RANGE);
	if(res != 0){
		#ifdef DEBUG
		printf("PWM Create Error\n");
		#endif
		return res;
	}
	pinMode(GPIO_MOTOR_SWITCH, INPUT);
	pinMode(GPIO_BRAKE1, INPUT);
        #ifdef BRAKE2
	pinMode(GPIO_BRAKE2, INPUT);
        #endif
	pinMode(GPIO_SPEED, INPUT);
	lcd_handler = lcdInit(LCD_ROWS, LCD_COLUMNS, LCD_BITS, LCD_RS, LCD_STRB, LCD_D0, LCD_D1, LCD_D2, LCD_D3, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
	
	res = pthread_create(&display_thr, NULL, display_thread, NULL);
	if(res != 0){
		#ifdef DEBUG
		printf("Display Thread Create Error\n");
		#endif
		return res;
	}
	
	res = pthread_create(&sensor_thr, NULL, sensor_thread, NULL);
	if(res != 0){
		#ifdef DEBUG
		printf("Sensor Thread Create Error\n");
		#endif
		return res;
	}
	
	return res;
}

void write_to_file(char* text){
        /* Open file to append, create if not existent*/
        FILE *f = fopen("/home/pi/AMT/log.txt", "a");
        if (f == NULL){
                    FILE *f = fopen("/home/pi/AMT/log.txt", "w");
                    if(f == NULL){
                    printf("Error opening file!\n");
                    return -1;
                }
        }

        /* print text */
        fprintf(f, "%s\n", text);

        fclose(f);
}

float read_velocity(){
        char buffer[BUFMAX + 1], tmp[256];
	char *bp = buffer, *ptr;
	int t=0, c, rpm;
        float result;


	FILE *in;
	while (EOF != (c = fgetc(stdin)) && (bp - buffer) < BUFMAX) {
		*bp++ = c;
	}
	*bp = 0;    // Null-terminate the string
        #ifdef DEBUG        
	        printf("read_velocity: Received Buffer: %s", buffer);
        #endif
        /*  Verarbeitung der Daten  */
        // Searches for 'RPM=' in output
        ptr = strstr(buffer, "RPM=");
        // Remove leading "RPM='"        
        ptr=ptr+sizeof(*ptr)*5;
        t = strcspn(ptr, "'");

        // Remove trailing "'"    
        strncpy(tmp, ptr, t); 
    
        // Char to Integer        
        rpm = atoi(tmp);
        // Compute speed out of rpm and wheel length in km/h
        result = rpm * WHEEL_LENGTH * 0.06;
    
        #ifdef DEBUG
                printf("rpm: %d\n", rpm);
                printf("velocity: %.2f\n", result);
        #endif
        return result
}
/****************************************************************************************************/
/*  Main / Geschwindigkeitsmessung								    */
/****************************************************************************************************/

int main(){

	if (setup_done == 0) {
		if(setup() != 0){
			return -1;
		} else {
			setup_done = 1;
		}
	}
	

        now = micros();
        current_speed = read_velocity();
        lastpeak = now;



	/*  Reaktion auf Geschwindigkeit */
	if(current_speed >= MAX_TEMPO && motor_limited == 0){
		motor_limited = 1;
	}else if(current_speed < MAX_TEMPO && motor_limited){
		motor_limited = 0;
	}
	
	/*  Ein- und Ausschalten des PWM-Signals  */
        if(brake_on == 0 && motor_on == 1 && motor_limited == 0){
                //Einschalten des PWM-Signals
                softPwmWrite(GPIO_PWM, (int)(PWM_RANGE * current_activation / 2));
                sleep(1);
                softPwmWrite(GPIO_PWM, (int)(PWM_RANGE * current_activation));
        }else{
                //Ausschalten des PWM-Signals
                softPwmWrite(GPIO_PWM, 0);
        }
        
        /* Log data to file*/
        char printout[256];
        sprintf(printout, "timestamp: %d, velocity: %.2fkm/h", now, current_speed);
        write_to_file(printout);
        sprintf(printout, "timestamp: %d, pwm-signal: %d", now, (int)(PWM_RANGE * current_activation));
        write_to_file(printout);

	delay(SPEED_UPDATE);
}
