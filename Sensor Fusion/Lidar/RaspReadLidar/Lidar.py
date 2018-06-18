import serial
import time
import numpy as np
import matplotlib.pyplot as plt

def readLidar():
    port = serial.Serial("/dev/ttyS0",115200, timeout=1)
    i = 0
    plt.axis([0,1000,0,1000])
    while 1:
        while(port.in_waiting >=9):
		if((b'Y' == port.read()) and (b'Y' == port.read())):
			DL = port.read()
			DH = port.read()
			Dtotal = (ord(DH)*256)+(ord(DL))
			for i in range(0,5):
				port.read()
			print(Dtotal)
			plt.scatter(i,Dtotal)
			plt.pause(0.005)
			i = i+1
			if Dtotal > 1000:
                            return
    plt.show()
	
readLidar()