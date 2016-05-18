import time
import os
import subprocess
from subprocess import call
import thread




def startQuarqd():
    print('starting quarqd')
    call("/home/pi/AMT/quarqd")
    print('started quarqd')
    
def startAnt():
    execfile("/home/pi/AMT/ant.py")
    print('started ant.py')
    
def startGps():
    execfile("/home/pi/AMT/gps.py")
    print('started gps.py')

def startSteuerung():
    call("/home/pi/AMT/steuerung")
    print('started steuerung')

# Create two threads as follows
try:
   thread.start_new_thread( startQuarqd )
   time.sleep(2)
   thread.start_new_thread( startAnt )
   thread.start_new_thread( startGps )
   time.sleep(2)
   thread.start_new_thread( startSteuerung )
except:
   print "Error: unable to start thread"
