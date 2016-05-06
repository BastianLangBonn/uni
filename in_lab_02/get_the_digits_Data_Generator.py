#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May  2 15:54:34 2016

@author: Alexander Moriarty
"""

import numpy as np
import time
#import collections 

zero  = "ZERO"
one   = "ONE"
two   = "TWO"
three = "THREE"
four  = "FOUR"
five  = "FIVE"
six   = "SIX"
seven = "SEVEN"
eight = "EIGHT"
nine  = "NINE"

letters = list(zero + one + two + three + four
               + five + six + seven + eight + nine)

d = {0:zero, 1:one, 2:two, 3:three, 4:four,
     5:five, 6:six, 7:seven, 8:eight, 9:nine}

numbers = np.random.randint(100,10000000000000000,100000)

NUMBERS = [("".join([d[int(i)] for i in list(str(j))])) for j in numbers]

training_data = list()
longest = 0


for N, n in zip(NUMBERS,numbers):
    letters_ = list(N)
    digits_ = "".join(np.sort(list(str(n))))
    np.random.shuffle(letters_)
    STRING_ = "".join(letters_)
    training_data.append((digits_,STRING_))

filename = "training_data-%s.txt" % time.strftime("%d.%m.%y-%H:%M:%S")

np.savetxt(filename,np.array(training_data),fmt="%s")

Training_Data = np.genfromtxt(filename,dtype='str')

