import numpy as np
from os import walk

files = []
for (dirpath, dirnames, filenames) in walk('./logs/1469449613/'):
    files.extend(filenames)
    break


print(dirpath)
print(dirnames)
print(files)
latitude = 0
longitude = 0
for file in files:
    data = np.genfromtxt(dirpath+file,delimiter=',')
    if len(data) > 0:
        latitude = data[6]
        longitude = data[7]
        print(latitude)
        print(longitude)