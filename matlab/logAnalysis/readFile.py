import numpy as np
from os import walk
import requestElevationData as request
import csv

files = []
for (dirpath, dirnames, filenames) in walk('./logs/1469449613/'):
    files.extend(filenames)
    break


print(dirpath)
print(dirnames)
print(files)
locations = []
searchString = ''
f = open('./processedLogs/1469449613/log.csv', 'w')
for file in files:
    with open(dirpath+file, 'r') as infile:
        csvReader = csv.reader(infile, delimiter=',')
        for line in csvReader:
            elevation = request.getElevation(line[6], line[7])
            print(str(line[6]) +';'+ str(line[7]) + ';' + str(elevation))
            f.write('{},{},{},{},{},{},{},{},{}\n'.format(str(line[0]),str(line[1]),\
            str(line[2]),str(line[3]),str(line[4]),str(line[5]),\
            str(line[6]),str(line[7]),str(elevation)))
f.close()
    
#    data = np.genfromtxt(dirpath+file,delimiter=',')
#    if len(data) > 0:
#        elevation.append(request.getElevation(data[6], data[7]))
#        f.write('This is a test\n')
        
        
#print(searchString)
