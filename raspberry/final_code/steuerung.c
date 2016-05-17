#include <wiringPi.h> 
#include <softPwm.h> 
#include <stdio.h> 
#include <lcd.h> 
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 



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


int _motor_on = 0;			// Legt fest ob der Motor eingeschaltet ist
int _brake_on = 0;			// Legt fest ob die Bremse betaetigt wird
int _motor_limited = 0;			// Legt das max Tempo für die Motorunterstuetzung fest

float _current_activation = 0;		// Legt den HIGH Anteil vom PWM-Signal fest
					// 0 <= current_activation <= 1
float _current_speed = 0;
float _current_latitude = 0.0;
float _current_longitude = 0.0;
int _lcd_handler;
char _setup_done = 0, _filename[256];

unsigned int _now;
unsigned int _lastpeak;

/****************************************************************************************************/
/*  Sensor Thread										            */
/****************************************************************************************************/

void *sensor_thread(void *arg){
    #ifdef DEBUG
        printf("Sensor thread started\n"); 
    #endif
	while(1){

		/*  Motor an- und ausschalten  */
		if(digitalRead(GPIO_MOTOR_SWITCH)){
            _motor_on++;
            if(_motor_on > 10){
                _motor_on = 0;
                #ifdef DEBUG
			        printf("Motor turned off\n");
			    #endif
            }
        _current_activation = _motor_on * 0.1;
        #ifdef DEBUG
		    printf("Motor activation set to %.2f.\n", _current_activation);
		#endif
		delay(200); //Notwendig wegen springen des Schalters 
		}
		
		/*  Bremsen  */
        #ifndef BRAKE2   								
		    if(digitalRead(GPIO_BRAKE1) == 0 && _brake_on == 0){
			    //Bremse neu betaetigt
			    _brake_on = 1;
			    #ifdef DEBUG
			        printf("Bremse gezogen\n");
			    #endif
		    }
        #endif
                
        #ifdef BRAKE2									
            if((digitalRead(GPIO_BRAKE1) == 0 || GPIO_BRAKE2 == 0 ) && _brake_on == 0){
                _brake_on = 1;
			    #ifdef DEBUG
			        printf("Bremse gezogen\n");
			    #endif
            }
        #endif
			
		#ifndef BRAKE2
		    if(digitalRead(GPIO_BRAKE1) == 1 && _brake_on == 1){
			    //Bremse wieder losgelassen
			    _brake_on = 0;
			    #ifdef DEBUG
			        printf("Bremse losgelassen\n");
			    #endif
		    }
        #endif
                
        #ifdef BRAKE2
		    if((digitalRead(GPIO_BRAKE1) == 1 || digitalRead(GPIO_BRAKE2)) == 1 _brake_on == 1){	// old:&&
			    //Bremse wieder losgelassen
			    _brake_on = 0;
			    #ifdef DEBUG
			        printf("Bremse losgelassen\n");
			    #endif
		    }
        #endif
		
		delay(SENSOR_UPDATE); //Verhindert busy-waiting
	}
	#ifdef DEBUG
        printf("Sensory thread ended\n"); 
    #endif
}

/****************************************************************************************************/
/*  Display Thread										    */
/****************************************************************************************************/

void *display_thread(void *arg){
    #ifdef DEBUG
        printf("Display Thread started\n"); 
    #endif
	while(1){
		lcdClear(_lcd_handler);
		lcdPrintf(_lcd_handler, "%d km/h", _current_speed);
		lcdPosition(_lcd_handler, 0, 1);
		if(_motor_on){
			lcdPrintf(_lcd_handler, "Motor an");
		}else{
			lcdPrintf(_lcd_handler, "Motor aus");
		}
		delay(DISPLAY_UPDATE);
	}
	#ifdef DEBUG
        printf("Display Thread Ended\n"); 
    #endif
}


void error(char *msg){
  perror(msg);
  exit(0);
}
/****************************************************************************************************/
/*  GPS Thread										    */
/****************************************************************************************************/
void *gps_thread(void *arg){
        
    #ifdef DEBUG
        printf("GPS thread started\n"); 
    #endif
    int sockfd, n;
    char *latitude, *longitude;        
    char buffer[256], tmp[256], *ptr;    
        
    memset(buffer, 0, 256);
	sockfd = createSockFd(2300);
    while(1){
        memset(buffer,0,256);
        memset(tmp,0,sizeof(buffer));
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0){
            error("ERROR reading from socket");
		}
        if(n>0){
            printf("Received message: %s\n", buffer);
                            
            // Get data out of message
            latitude = strtok(buffer, ";");
            latitude = strtok(NULL, ";");
            longitude = strtok(NULL, ";");
            
            latitude = strtok(latitude, "=");
            latitude = strtok(NULL, "=");
            _current_latitude = atof(latitude);
            
            longitude = strtok(longitude, "=");
            longitude = strtok(NULL, "=");
            _current_longitude = atof(longitude);
            #ifdef DEBUG
                printf("GPS THREAD: extracted position:%.2fN;%.2fE\n", _current_latitude, _current_longitude); 
            #endif
        }
    }
    #ifdef DEBUG
        printf("GPS thread terminated\n"); 
    #endif
}

/****************************************************************************************************/
/*  ANT+ Thread										    */
/****************************************************************************************************/
void *ant_thread(void *arg){
    #ifdef DEBUG
        printf("ANT+ Thread started\n"); 
    #endif
	int sockfd, n;   
    char buffer[256], tmp[256], *ptr;
    int t=0, rpm;
    sockfd = createSockFd(2301);
	memset(buffer, 0, 256);
    while(1){
        memset(buffer,0,256);
        memset(tmp,0,sizeof(buffer));
        ptr = NULL;
        n = read(sockfd,buffer,255);
        if (n < 0) 
            error("ERROR reading from socket");
        if(n>0){
            printf("Received message: %s\n",buffer);
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
			_current_speed = rpm * WHEEL_LENGTH * 0.06;
			#ifdef DEBUG
				printf("rpm: %d\n", rpm);
				printf("velocity: %.2f\n", _current_speed);
			#endif
        }
    }
    	
	#ifdef DEBUG
        printf("ANT+ Thread Ended\n"); 
    #endif
}

/****************************************************************************************************/
/*  CreateSocketFd										    */
/*  Creates a socket connection to the given port number on localhost 				*/
/****************************************************************************************************/
int createSockFd(int portno){
	int sockfd;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0){
        error("ERROR opening socket");
	}
    server = gethostbyname("localhost");
    memset((char *) &serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0){ 
        error("ERROR connecting");
	}

	return sockfd;
}
/****************************************************************************************************/
/*  Setup											    */
/****************************************************************************************************/

int setup(){
	pthread_t sensor_thr, display_thr, gps_thr, ant_thr;

    #ifdef DEBUG
        printf("Setup started\n"); 
    #endif
    _lastpeak  = micros();
    sprintf(_filename, "/home/pi/AMT/log/log_%d.txt", _lastpeak);

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
	_lcd_handler = lcdInit(LCD_ROWS, LCD_COLUMNS, LCD_BITS, LCD_RS, LCD_STRB, LCD_D0, LCD_D1, LCD_D2, LCD_D3, LCD_D4, LCD_D5, LCD_D6, LCD_D7);
		
    #ifdef DEBUG
        printf("Setup done\n"); 
    #endif
	
	return res;
}

/****************************************************************************************************/
/*  createThreads                                                                                 */
/****************************************************************************************************/
void createThreads(){
	// Create Display Thread
	res = pthread_create(&display_thr, NULL, display_thread, NULL);
	if(res != 0){
		#ifdef DEBUG
		    printf("Display Thread Create Error\n");
		#endif
		return res;
	}
	
	// Create Sensor Thread
	res = pthread_create(&sensor_thr, NULL, sensor_thread, NULL);
	if(res != 0){
		#ifdef DEBUG
		    printf("Sensor Thread Create Error\n");
		#endif
		return res;
	}
	
	// Create GPS Thread
    res = pthread_create(&gps_thr, NULL, gps_thread, NULL);
    if(res != 0){
		#ifdef DEBUG
		    printf("GPS Thread Create Error\n");
		#endif
		return res;
	}

	// Create ANT+ Thread
	res = pthread_create(&ant_thr, NULL, ant_thread, NULL);
    if(res != 0){
		#ifdef DEBUG
		    printf("ANT+ Thread Create Error\n");
		#endif
		return res;
	}
}

/****************************************************************************************************/
/*  Write_to_file                                                                                   */
/*                                                                                                  */
/*  Writes information into a file                            									    */
/****************************************************************************************************/
void write_to_file(char* text){
        /* Open file to append, create if not existent*/
        FILE *f = fopen(_filename, "a");
        if (f == NULL){
            FILE *f = fopen(_filename, "w");
            if(f == NULL){
                printf("Error opening file: %s!\n", _filename);
                return;
            }
        }

        /* print text */
        fprintf(f, "%s\n", text);

        fclose(f);
}

/****************************************************************************************************/
/*  check_speed_limit                                                    						    */
/****************************************************************************************************/
/* Check if motor needs to be switched off due to speed limit */
int check_speed_limit(){
	if(_current_speed >= MAX_TEMPO && _motor_limited == 0){
		return 1;
	}else{
		return 0;
	}
}

/****************************************************************************************************/
/*  send_motor_signal			                					    */
/****************************************************************************************************/
/* Sends the Pwm signal to the motor depending on some values */
void send_motor_signal(){
    /*  Ein- und Ausschalten des PWM-Signals  */
    if(_brake_on == 0 && _motor_on > 0 && _motor_limited == 0){
        //Einschalten des PWM-Signals
        softPwmWrite(GPIO_PWM, (int)(PWM_RANGE * _current_activation / 2));
        sleep(1);
        softPwmWrite(GPIO_PWM, (int)(PWM_RANGE * _current_activation));
    }else{
        //Ausschalten des PWM-Signals
        softPwmWrite(GPIO_PWM, 0);
    }
}


/****************************************************************************************************/
/*  log_data			                        					    */
/****************************************************************************************************/
// Log important data into file
void log_data(){        
/* Log data to file*/
    char printout[256];
    sprintf(printout, "timestamp: %d, velocity: %.2fkm/h", _now, _current_speed);
    write_to_file(printout);
    sprintf(printout, "timestamp: %d, pwm-signal: %d", _now, (int)(PWM_RANGE * _current_activation));
    write_to_file(printout);     
    sprintf(printout, "timestamp: %d, position: %.2fN, %.2fE", _now, _current_latitude, _current_longitude);
    write_to_file(printout);   

}

/****************************************************************************************************/
/*  Main                                							    */
/****************************************************************************************************/

int main(){
	
    setup();
    while(1){
        _now = micros();
        _motor_limited = check_speed_limit();
        send_motor_signal();
        _lastpeak = _now;
        log_data();

        delay(SPEED_UPDATE);
    }
}
