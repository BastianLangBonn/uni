#!/usr/bin/python
import threading
import parameters as p
import time
import socket
import serial

class Gps(threading.Thread):
    def __init__(self, name, parentThread):
        super(Gps, self).__init__()
        self.name = name
        self.parentThread = parentThread
        
    def run(self):
        print "Starting " + self.name
        nChars = 0
        messageLength = 0
        quality = 0
        satellite = 0

        height = 0.0
        latitude = 0.0
        longitude = 0.0

        input = ""
        dataTime = ""
        checksum = ""

        dataList = []

        print 'open port'
        # open UART
        UART = serial.Serial("/dev/ttyUSB0", 4800)
        print 'port open'


        print 'open file'
        # open output file
        filename = '/home/pi/control/out/gps_out_{}'.format(int(round(time.time())));
        f = open(filename, 'w')
        print 'file open'

        # Prevent files from getting too big
        nLines = 0;
        nFiles = 1;


        while True:

            if nLines > 1000000:
                f.close();
                filename = '/home/pi/control/out/gps_out_{}_{}'.format(nFiles, int(round(time.time())));
                f = open(filename, 'w');
                nLines = 0;
                nFiles += 1;

            nChars = 0
            # emtpy string
            input = ""

            # receive nChars
            nChars = UART.read()

	        # Check for transmission
            if nChars == "$":

                # read nChars 2-6
                for Counter in range(4):
                    nChars = 0
                    nChars = UART.read()
                    input = input + str(nChars)

                    # Check if GGA Protokoll is being sent
                    if input == "GPGG":
                        # read until new line
                        while nChars != "\n":
                            nChars = 0
                            nChars = UART.read()
                            input = input + str(nChars)

                        input = input.replace("\r\n", "")

                        # Split data
                        dataList = input.split(",")

                        # Determine length of message
                        messageLength = len(input)
                        # read time
                        dataTime = dataList[1]
                        dataTime = dataTime[0:2] + ":" + dataTime[2:4] + ":" + dataTime[4:6]

        			    # read longitude and latitude
                        latitude = int(float(dataList[2]) / 100)
                        longitude = int(float(dataList[4]) / 100)

                        latitudeMinutes = float(dataList[2]) - (latitude * 100)
                        longitudeMinutes = float(dataList[4]) - (longitude * 100)

                        latitude = round(latitude + (latitudeMinutes / 60), 6)
                        longitude = round(longitude + (longitudeMinutes / 60), 6)
                        
                        

                        # Signalquality herausfiltern
                        quality = int(dataList[6])

        			    # Anzahl der satellite herausfiltern
                        satellite = int(dataList[7])

	        		    # height herausfiltern
                        height = float(dataList[9])
                        
                        self.parentThread.notifyGpsUpdate(latitude, longitude, height)

	        		    # checksum auslesen
                        checksum = dataList[14]

                        f.write('{}: {}\n'.format(int(round(time.time())),input));
                        nLines += 1;
