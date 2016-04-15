#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <libusb-1.0/libusb.h>

#include "configuration.h"
#include "ant.h"

static void (*eventFuncs[ANT_MAX_CHANNELS])(void *data, unsigned char *message) = {NULL, NULL, NULL, NULL};
static void *privateData[ANT_MAX_CHANNELS];
static unsigned char rxMessage[ANT_MAX_MESSAGE_SIZE] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
unsigned char txMessage[ANT_MAX_MESSAGE_SIZE+10];
unsigned char txAckMessage[ANT_MAX_MESSAGE_SIZE];

static void ProcessMessage(void);
static void SendMessage(void);
static void Transmit(unsigned char *msg, int length);

libusb_device_handle *dev_handle;
libusb_context *ctx = NULL;
unsigned char ep_out = 0x01;
unsigned char ep_in = 0x81;
	
void USB_InitCommunication(void) {
	
	libusb_device **devs;
	
	uint16_t vid = 0x0fcf;
	uint16_t pid = 0x1008;

	int r;
	ssize_t cnt;
		
	printf("Init USB connection\n");
	
	r = libusb_init(&ctx);
	if(r < 0) {
		printf("Init Error %d\n",r);
		return;
	}
	libusb_set_debug(ctx, 3);

	cnt = libusb_get_device_list(ctx, &devs);
	if(cnt < 0) {
		printf("Get Device Error\n");
		return;
	}
	printf("%d Devices in list.\n",(int)cnt);

	dev_handle = libusb_open_device_with_vid_pid(ctx, vid, pid);
	
	if(dev_handle == NULL) {
		printf("Cannot open device\n");
	} else {
		printf("Device Opened\n");
	}
	
	libusb_free_device_list(devs, 1);

	if(libusb_kernel_driver_active(dev_handle, 0) == 1) { 
		
		printf("Kernel Driver Active\n");
		
		if(libusb_detach_kernel_driver(dev_handle, 0) == 0) { 
			printf("Kernel Driver Detached!\n");
		}
		
	}
	r = libusb_claim_interface(dev_handle, 0); 
	if(r < 0) {
		printf("Cannot Claim Interface\n");
		return;
	}
	printf("Claimed Interface\n");
	
	return;
}
		
void USB_ReadByte(void) {
	
	int actual;
	int r;
	unsigned char *c;
	c = (unsigned char *)malloc(128);

	r = libusb_bulk_transfer(dev_handle, (ep_in | LIBUSB_ENDPOINT_IN), c, 128, &actual, 5);
		
	if(r == 0) {
		int i;
		printf("USB_READ_BYTE() -> actual received bytes: %d\ndata: ",actual);
		for(i=0;i<actual;i++) { 
			printf("%#x ",c[i]);
			ANT_ReceiveByte(c[i]);
		}
		printf("\n");
	} else {
		switch(r) {
			
			case LIBUSB_ERROR_TIMEOUT:
				break;
			
			default:
				printf("USB_READ_BYTE() -> result(error): %d\n",r);
				break;
				
			}
	}
	
	free(c);
		
}
	
void USB_ExitCommunication() {
	
	int r;
	
	r = libusb_release_interface(dev_handle, 0); 
	if(r!=0) {
		printf("Cannot Release Interface\n");
		return;
	}
	printf("Released Interface\n");

	libusb_close(dev_handle);
	libusb_exit(ctx);
	
}

void ANT_ResetSystem(void){
	txMessage[ANT_OFFSET_LENGTH] = 1;
	txMessage[ANT_OFFSET_ID] = ANT_SYSTEM_RESET;

	SendMessage();
}

void ANT_AssignChannelEventFunction(int channel,
				    void func(void *data, unsigned char* message), 
				    void *data) {
	if(channel >= 0 && channel < 4){
		eventFuncs[channel] = func;
		privateData[channel] = data;
	}
}

void ANT_AssignChannel(const unsigned char channel, const unsigned char type, const unsigned char network) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 3;
	txMessage[ANT_OFFSET_ID] = ANT_ASSIGN_CHANNEL;
	*data++ = channel;
	*data++ = type;
	*data++ = network;

	SendMessage();

}

void ANT_UnassignChannel(const unsigned char channel) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 1;
	txMessage[ANT_OFFSET_ID] = ANT_UNASSIGN_CHANNEL;
	*data = channel;

	SendMessage();
}

void ANT_SetChannelSearchTimeout(const unsigned char channel, const unsigned char search_timeout) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;	

	txMessage[ANT_OFFSET_LENGTH] = 2;
	txMessage[ANT_OFFSET_ID] = ANT_SEARCH_TIMEOUT;
	*data++ = channel;
	*data++ = search_timeout;

	SendMessage();
}

void ANT_RequestMessage(const unsigned char channel, const unsigned char request) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 2;
	txMessage[ANT_OFFSET_ID] = ANT_REQ_MESSAGE;
	*data++ = channel;
	*data++ = request;

	SendMessage();
}


void ANT_SetChannelID(const unsigned char channel, const unsigned short device, const unsigned char deviceType, const unsigned char txType) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 5;
	txMessage[ANT_OFFSET_ID] = ANT_CHANNEL_ID;
	*data++ = channel;
	*data++ = device & 0xff;
	*data++ = (device >> 8) & 0xff;
	*data++ = deviceType;
	*data++ = txType;

	SendMessage();
}

void ANT_SetChannelPeriod(const unsigned char channel, const unsigned short period) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 3;
	txMessage[ANT_OFFSET_ID] = ANT_CHANNEL_PERIOD;
	*data++ = channel;
	*data++ = period & 0xff;
	*data++ = (period >> 8) & 0xff;

	SendMessage();
}

void ANT_SetChannelFreq(const unsigned char channel, const unsigned char frequency) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 2;
	txMessage[ANT_OFFSET_ID] = ANT_CHANNEL_FREQUENCY;
	*data++ = channel;
	*data++ = frequency;

	SendMessage();
}

void ANT_SetNetworkKey(const unsigned char net, const unsigned char *key) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;
	int i;

	txMessage[ANT_OFFSET_LENGTH] = 9;
	txMessage[ANT_OFFSET_ID] = ANT_SET_NETWORK;
	*data++ = net;
	for (i = 0; i < ANT_KEY_LENGTH; i++)
		*data++ = key[i];

	SendMessage();

}

void SendAckMessage( void ) {

    memcpy(txMessage, txAckMessage, ANT_MAX_MESSAGE_SIZE);
	SendMessage();

}

void ANT_SetAutoCalibrate(const unsigned char channel, const int autozero) { 
	unsigned char *data = txAckMessage + ANT_OFFSET_DATA;

	txAckMessage[ANT_OFFSET_LENGTH] = 4;
	txAckMessage[ANT_OFFSET_ID] = ANT_ACK_DATA;
	*data++ = channel;
	*data++ = ANT_SPORT_CALIBRATION_MESSAGE;
	*data++ = ANT_SPORT_CALIBRATION_REQUEST_AUTOZERO_CONFIG;
	*data++ = autozero ? ANT_SPORT_AUTOZERO_ON : ANT_SPORT_AUTOZERO_OFF;

	SendAckMessage();
}

void ANT_RequestCalibrate(const unsigned char channel) { 
	unsigned char *data = txAckMessage + ANT_OFFSET_DATA;

	txAckMessage[ANT_OFFSET_LENGTH] = 4;
	txAckMessage[ANT_OFFSET_ID] = ANT_ACK_DATA;
	*data++ = channel;
	*data++ = ANT_SPORT_CALIBRATION_MESSAGE;
	*data++ = ANT_SPORT_CALIBRATION_REQUEST_MANUALZERO;
	*data++ = 0;

	SendAckMessage();

}

void ANT_Open(const unsigned char channel) {
	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 1;
	txMessage[ANT_OFFSET_ID] = ANT_OPEN_CHANNEL;
	*data++ = channel;

	SendMessage();
}

void ANT_Close(const unsigned char channel) {

	unsigned char *data = txMessage + ANT_OFFSET_DATA;

	txMessage[ANT_OFFSET_LENGTH] = 1;
	txMessage[ANT_OFFSET_ID] = ANT_CLOSE_CHANNEL;
	*data++ = channel;

	SendMessage();
}

void SendMessage(void) {
        
    int i;
	const int length = txMessage[ANT_OFFSET_LENGTH] + ANT_OFFSET_DATA;
	unsigned char checksum = ANT_SYNC_BYTE;
	
	txMessage[ANT_OFFSET_SYNC] = ANT_SYNC_BYTE;

	for (i = ANT_OFFSET_LENGTH; i < length; i++)
		checksum ^= txMessage[i];
	
	txMessage[i++] = checksum;

	if (quarqd_config.debug_level & DEBUG_LEVEL_ANT_MESSAGES) {
	  int j;
	  for (j=0; j<i; j++) {
#ifdef DEBUG	    
	    if (1) {
#else       
	    if (j<4) {
#endif
	      fprintf(stderr, "0x%02x ",txMessage[j]);	      
	    } else {
	      fprintf(stderr, "0x.. ");
	    }
	  }
	  fprintf(stderr,"\n");	  
	}

	txMessage[i++] = 0x0;
	txMessage[i++] = 0x0;
	txMessage[i++] = 0x0;
	txMessage[i++] = 0x0;
	txMessage[i++] = 0x0;

	Transmit(txMessage, i);
}

static void Transmit(unsigned char *msg, int length) {
#	if defined(DEBUG)
	if (quarqd_config.debug_level & DEBUG_LEVEL_ANT_MESSAGES) {
		fprintf(stderr,"-> txmessage =");
		int i;
		for (i = 0; i < length; ++i) {
			fprintf(stderr," 0x%02x",msg[i]);
		}
		fprintf(stderr,"\n");
	}
#	endif
    
    int r;
    int actual;
                
    r = libusb_bulk_transfer(dev_handle, (ep_out | LIBUSB_ENDPOINT_OUT), msg, length, &actual, 0); 
	
	if(r == 0 && actual == length) { 
		printf("Writing Successful! %d Bytes written.\n",actual);
	} else {
		printf("Write Error! actual: %d, length: %d\n",actual,length);
	}
}

void ANT_ReceiveByte(unsigned char byte) {

	enum States {ST_WAIT_FOR_SYNC, ST_GET_LENGTH, ST_GET_MESSAGE_ID, ST_GET_DATA, ST_VALIDATE_PACKET};
	static enum States state = ST_WAIT_FOR_SYNC;
	static int length = 0;
	static int bytes = 0;
	static int checksum = ANT_SYNC_BYTE;

#	if defined(DEBUG)
	if (quarqd_config.debug_level & DEBUG_LEVEL_ANT_MESSAGES) {
		if(state == ST_WAIT_FOR_SYNC) {
			fprintf(stderr,"<- rxmessage = %02x",byte);
		}
		else if(state == ST_VALIDATE_PACKET) {
			fprintf(stderr," %02x\n",byte);
		}
		else {
			fprintf(stderr," %02x",byte);
		}
	}
#	endif

	switch (state) {
		case ST_WAIT_FOR_SYNC:
			if (byte == ANT_SYNC_BYTE) {
				state = ST_GET_LENGTH;
				checksum = ANT_SYNC_BYTE;
			}
			break;
			
		case ST_GET_LENGTH:
			if ((byte == 0) || (byte > ANT_MAX_LENGTH)) {
				state = ST_WAIT_FOR_SYNC;
			}
			else {
			  rxMessage[ANT_OFFSET_LENGTH] = byte;
				checksum ^= byte;
				length = byte;
				bytes = 0;
				state = ST_GET_MESSAGE_ID;
			}
			break;
	
		case ST_GET_MESSAGE_ID:
			rxMessage[ANT_OFFSET_ID] = byte;
			checksum ^= byte;
			state = ST_GET_DATA;
			break;
	
		case ST_GET_DATA:
			rxMessage[ANT_OFFSET_DATA + bytes] = byte;
			checksum ^= byte;
			if (++bytes >= length){
				state = ST_VALIDATE_PACKET;
			}
			break;

		case ST_VALIDATE_PACKET:
			if (checksum == byte){
				ProcessMessage();
			}
			state = ST_WAIT_FOR_SYNC;
			break;
	}
}


static void HandleChannelEvent(void) {
	int channel = rxMessage[ANT_OFFSET_DATA] & 0x7;
	if(channel >= 0 && channel < 4) {
	  if(eventFuncs[channel] != NULL) {	    
	    eventFuncs[channel](privateData[channel],rxMessage);
	  }
	}
}

static void ProcessMessage(void) {

	switch (rxMessage[ANT_OFFSET_ID]) {
		case ANT_ACK_DATA:
		case ANT_BROADCAST_DATA:
		case ANT_CHANNEL_STATUS:
		case ANT_CHANNEL_ID:
		case ANT_BURST_DATA:
			HandleChannelEvent();
			break;

		case ANT_CHANNEL_EVENT:
		  switch (rxMessage[ANT_OFFSET_MESSAGE_CODE]) {
		  case EVENT_TRANSFER_TX_FAILED:
		    fprintf(stderr, "\nResending ack.\n");
		    SendAckMessage();
		    break;
		  case EVENT_TRANSFER_TX_COMPLETED:		    
		    fprintf(stderr, "\nAck sent.\n");
		    /* fall through */
		  default:
		    HandleChannelEvent();
		  }
		  break;
			
		case ANT_VERSION:
			break;
			
		case ANT_CAPABILITIES:
			break;
			
		case ANT_SERIAL_NUMBER:
			break;
			
		default:
			break;
	}
}
