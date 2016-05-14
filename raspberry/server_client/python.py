import serial
import sys
import time

Zeichen = 0
Laenge = 0
Qualitaet = 0
Satelliten = 0

Hoehe = 0.0
Breitengrad = 0.0
Laengengrad = 0.0

Input = ""
Uhrzeit = ""
Checksumme = ""

Datenliste = []

# UART oeffnen
UART = serial.Serial("/dev/ttyUSB0", 4800)
#UART.open()

# Startmeldung
print ""
print "+---------------------------------------------------------------------+"
print "| Dieses Programm empfaengt Daten einer Holux GPS-Maus,               |"
print "| die mittels GAA-Protokoll uebertragen wurden.                       |"
print "| Der empfangene Datensatz wird zerlegt und in der Konsole angezeigt. |"
print "+---------------------------------------------------------------------+"
print ""

while True:

	Zeichen = 0

	# String leeren
	Input = ""
	
	# Zeichen empfangen
	Zeichen = UART.read() 
	
	# Pruefen ob Uebertragung gestartet wurde
	if Zeichen == "$":

		# Zeichen 2-6 einlesen
		for Counter in range(4):

			Zeichen = 0
			Zeichen = UART.read()
			Input = Input + str(Zeichen)
	
		# Pruefen ob das GGA Protokoll gesendet wird
		if Input == "GPGG":

			# Zeichen empfangen bis ein LF als Abschluss kommt
			while Zeichen != "\n":
				Zeichen = 0
				Zeichen = UART.read()
				Input = Input + str(Zeichen)
				
			Input = Input.replace("\r\n", "")
	
			# Datensatz nach jedem "," trennen und in einer Liste speichern
			Datenliste = Input.split(",")

			# Laenge des Datensatzes feststellen
			Laenge_Daten = len(Input)

			# Uhrzeit herausfiltern
			Uhrzeit = Datenliste[1]
			Uhrzeit = Uhrzeit[0:2] + ":" + Uhrzeit[2:4] + ":" + Uhrzeit[4:6]

			# Laengen und Breitengrad herausfiltern und berechnen
			Breitengrad = int(float(Datenliste[2]) / 100)
			Laengengrad = int(float(Datenliste[4]) / 100)
			
			Breitenminute = float(Datenliste[2]) - (Breitengrad * 100)
			Laengenminute = float(Datenliste[4]) - (Laengengrad * 100)

			Breite = round(Breitengrad + (Breitenminute / 60), 6)
			Laenge = round(Laengengrad + (Laengenminute / 60), 6)

			# Signalqualitaet herausfiltern
			Qualitaet = int(Datenliste[6])

			# Anzahl der Satelliten herausfiltern
			Satelliten = int(Datenliste[7])

			# Hoehe herausfiltern
			Hoehe = float(Datenliste[9])
			
			# Checksumme auslesen
			Checksumme = Datenliste[14]

			# Ausgabe
			print Input
			print ""
			print "Laenge des Datensatzes:", Laenge_Daten, "Zeichen"
			print "Uhrzeit:", Uhrzeit
			print "Breitengrad:", Breite, "Grad", Datenliste[3]
			print "Laengengrad:", Laenge, "Grad", Datenliste[5]
			print "Hoehe ueber dem Meeresspiegel:", Hoehe, Datenliste[10]
			print "GPS-Qualitaet:", Qualitaet
			print "Anzahl der Satelliten:", Satelliten
			print "Checksumme:", Checksumme
			print "-------------------------------------------"
