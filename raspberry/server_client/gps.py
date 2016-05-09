# Taken from http://kampis-elektroecke.de/wp-content/uploads/2015/09/GPS.py_.txt
import serial
import sys
import time
import socket

nChars = 0
messageLength = 0
quality = 0
satellite = 0

height = 0.0
latitude = 0.0
longitude = 0.0

input = ""
time = ""
checksum = ""

dataList = []

print 'open port'
# open UART
UART = serial.Serial("/dev/ttyUSB0", 4800)
print 'port open'


print 'open file'
# open output file 
filename = '/home/pi/out/gps_out_{}'.format(time.time());
f = open(filename, 'w')
print 'file open'

# Prevent files from getting too big
nLines = 0;
nFiles = 1;

# Initial Message
print ""
print "+---------------------------------------------------------------------+"
print "| Dieses Programm empfaengt Daten einer Holux GPS-Maus,               |"
print "| die mittels GAA-Protokoll uebertragen wurden.                       |"
print "| Der empfangene Datensatz wird zerlegt und in der Konsole angezeigt. |"
print "+---------------------------------------------------------------------+"
print ""

while True:

        if nLines > 1000000:
                f.close();
                filename = '/home/pi/out/gps_out_{}_{}'.format(nFiles, time.time());
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
			time = dataList[1]
			time = time[0:2] + ":" + time[2:4] + ":" + time[4:6]

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
			
			# checksum auslesen
			checksum = dataList[14]

			# Ausgabe
                        f.write('{}\n'.format(input));
                        nLines += 1;
			print input
			print ""
			print "messageLength des Datensatzes:", messageLength_Daten, "nChars"
			print "time:", time
			print "latitude:", latitude, "Grad", dataList[3]
			print "longitude:", longitude, "Grad", dataList[5]
			print "height ueber dem Meeresspiegel:", height, dataList[10]
			print "GPS-quality:", quality
			print "Anzahl der satellite:", satellite
			print "checksum:", checksum
			print "-------------------------------------------"
   
                
