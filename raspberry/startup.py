import time
from subprocess import call
call("./quarqd")
time.sleep(2)
execfile("./quarqd.py")