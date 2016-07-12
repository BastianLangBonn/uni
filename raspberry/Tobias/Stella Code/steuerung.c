#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h> 
#include <lcd.h> 
#include <pthread.h>
#include <unistd.h>


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
#define WHEEL_LENGTH        1.445
#define MAX_TEMPO           25      //Legt die maximale Geschwindigkeit in km/h fest

/*  Delay  */
#define DISPLAY_UPDATE      1000
#define SENSOR_UPDATE       20
#define SPEED_UPDATE        20



/****************************************************************************************************/
/*  Variablen											    */
/****************************************************************************************************/


int motor_on = 0;			// Legt fest ob der Motor eingeschaltet ist
int brake_on = 0;			// Legt fest ob die Bremse betaetigt wird
int motor_limited = 0;			// Legt das max Tempo für die Motorunterstuetzung fest

float current_value = 0.2;		// Legt den HIGH Anteil vom PWM-Signal fest
					// 0 <= current_value <= 1
int actual_speed = 0;
int lcd_handler;


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
		lcdPrintf(lcd_handler, "%d km/h", actual_speed);
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

/****************************************************************************************************/
/*  Main / Geschwindigkeitsmessung								    */
/****************************************************************************************************/

int main(){
	if(setup() != 0){
		return -1;
	}
	
	unsigned int now;
	unsigned int lastpeak = micros();
	
	while(1){
		/*  Ermittlung der Geschwindigkeit  */
		if(digitalRead(GPIO_SPEED)){
			now = micros();
			actual_speed =(int) (WHEEL_LENGTH * 3600000000)/((now - lastpeak) * 1000);
			lastpeak = now;
			#ifdef DEBUG
			printf("Geschwindigkeitssensor ausgelöst, aktuelle Geschwindigkeit: %d\n", actual_speed);
			printf("lastpeak = %d\n", lastpeak);
			printf("now = %d\n", now);
			#endif
			lastpeak = now;
		}else if(micros() - lastpeak > 2000000){
			//Seit 2 Sekunden kein Signal mehr eingegangen, Geschwindigkeit wird auf 0 gesetzt
			actual_speed = 0;
		}
		
		/*  Ermittlung der Geschwindigkeit  */
		//TODO alter Code raus und Socket-Code rein
		
		
		/*  Reaktion auf Geschwindigkeit */
		if(actual_speed >= MAX_TEMPO && motor_limited == 0){
			motor_limited = 1;
		}else if(actual_speed < MAX_TEMPO && motor_limited){
			motor_limited = 0;
		}
		
		/*  Ein- und Ausschalten des PWM-Signals  */
                if(brake_on == 0 && motor_on == 1 && motor_limited == 0){
                        //Einschalten des PWM-Signals
                        softPwmWrite(GPIO_PWM, (int)(PWM_RANGE * current_value / 2));
                        sleep(1);
                        softPwmWrite(GPIO_PWM, (int)(PWM_RANGE * current_value));
                }else{
                        //Ausschalten des PWM-Signals
                        softPwmWrite(GPIO_PWM, 0);
                }
                
		delay(SPEED_UPDATE);
	}
	return 0;
}