import matplotlib.pyplot as plt
import numpy as np

x_origin = -24.7/2 # x-center between wheels


data = np.genfromtxt('SEE_Experiment1.csv', delimiter=',', skip_header=2)

# Data as in experiment
left_wheel = data[:,1:3]
right_wheel = data[:,3:5]

# Shifted so that midpoint between wheels are new origin
left_wheel[:,0] = left_wheel[:,0] - x_origin
right_wheel[:,0] = right_wheel[:,0] - x_origin

plt.figure(1)                # figure 1 current; subplot(212) still current
plt.subplot(111)             # make subplot(211) in figure1 current
plt.title('Driving forward experiment')
plt.xlabel('x in cm')
plt.ylabel('y in cm')
plt.plot(left_wheel[:,0], left_wheel[:,1],'ro')
plt.plot(right_wheel[:,0], right_wheel[:,1], 'bo')
# Plot robot center of movement
plt.plot(right_wheel[:,0] + left_wheel[:,0],right_wheel[:,1] + (right_wheel[:,1] - left_wheel[:,1]) / 2, 'yo')
# add orientation
plt.plot(0,0, 'go') # Starting position
plt.axis([-20, 20, -1, 30])
plt.show
