import matplotlib.pyplot as plt
import numpy as np
import pylab
from collections import OrderedDict

x_origin = -24.7/2 # x-center between wheels


data = np.genfromtxt('SEE_Experiment1.csv', delimiter=',', skip_header=2)

# Data as in experiment
left_wheel = data[:,1:3]
right_wheel = data[:,3:5]

# Shifted so that midpoint between wheels are new origin
left_wheel[:,0] = left_wheel[:,0] - x_origin
right_wheel[:,0] = right_wheel[:,0] - x_origin

plt.figure(1)                # figure 1 current; subplot(212) still current
plt.subplot(111)            # make subplot(211) in figure1 current
plt.title('Driving forward')
plt.xlabel('x in cm')
plt.ylabel('y in cm')
plt.plot(left_wheel[:,0], left_wheel[:,1],'ro', label='left wheel')
plt.plot(right_wheel[:,0], right_wheel[:,1], 'bo', label='right wheel')
# Plot robot center of movement
plt.plot(left_wheel[:,0] + (right_wheel[:,0] - left_wheel[:,0])/2,left_wheel[:,1] + (right_wheel[:,1] - left_wheel[:,1]) / 2, 'yo', label='center of motion')
# add orientation
plt.plot(0,0, 'go', label='start position') # Starting position
plt.axis([-20, 20, -1, 30])
handles, labels = plt.gca().get_legend_handles_labels()
by_label = OrderedDict(zip(labels, handles))
pylab.legend(by_label.values(), by_label.keys(), loc='lower left')
plt.show

##################################################
# Second Experiment
##################################################

data = np.genfromtxt('SEE_Experiment1_2.csv', delimiter=',', skip_header=2)

# Data as in experiment
left_wheel = data[:,1:3]
right_wheel = data[:,3:5]

# Shifted so that midpoint between wheels are new origin
left_wheel[:,0] = left_wheel[:,0] - x_origin
right_wheel[:,0] = right_wheel[:,0] - x_origin

plt.figure(2)                # figure 1 current; subplot(212) still current
plt.subplot(111)            # make subplot(211) in figure1 current
plt.title('Right Arc')
plt.xlabel('x in cm')
plt.ylabel('y in cm')
plt.plot(left_wheel[:,0], left_wheel[:,1],'ro', label='left wheel')
plt.plot(right_wheel[:,0], right_wheel[:,1], 'bo', label='right wheel')
# Plot robot center of movement
plt.plot(left_wheel[:,0] + (right_wheel[:,0] - left_wheel[:,0])/2,right_wheel[:,1] + (left_wheel[:,1] - right_wheel[:,1]) / 2, 'yo', label='center of motion')
# add orientation
plt.plot(0,0, 'go', label='start position') # Starting position
plt.axis([-1, 20, -1, 35])
handles, labels = plt.gca().get_legend_handles_labels()
by_label = OrderedDict(zip(labels, handles))
pylab.legend(by_label.values(), by_label.keys(), loc='upper right')
plt.show

##################################################
# Third Experiment
##################################################

data = np.genfromtxt('SEE_Experiment1_3.csv', delimiter=',', skip_header=2)

# Data as in experiment
left_wheel = data[:,1:3]
right_wheel = data[:,3:5]

# Shifted so that midpoint between wheels are new origin
left_wheel[:,0] = left_wheel[:,0] - x_origin
right_wheel[:,0] = right_wheel[:,0] - x_origin

plt.figure(3)                # figure 1 current; subplot(212) still current
plt.subplot(111)            # make subplot(211) in figure1 current
plt.title('Left Arc')
plt.xlabel('x in cm')
plt.ylabel('y in cm')
plt.plot(left_wheel[:,0], left_wheel[:,1],'ro', label='left wheel')
plt.plot(right_wheel[:,0], right_wheel[:,1], 'bo', label='right wheel')
# Plot robot center of movement
plt.plot(left_wheel[:,0] + (right_wheel[:,0] - left_wheel[:,0])/2,right_wheel[:,1] + (left_wheel[:,1] - right_wheel[:,1]) / 2, 'yo', label='center of motion')
# add orientation
plt.plot(0,0, 'go', label='start position') # Starting position
plt.axis([-20, 1, -1, 35])
handles, labels = plt.gca().get_legend_handles_labels()
by_label = OrderedDict(zip(labels, handles))
pylab.legend(by_label.values(), by_label.keys(), loc='upper left')
plt.show