import time
from beacontools import BeaconScanner, IBeaconFilter
import pandas as pd
from sklearn.neighbors import KNeighborsClassifier
from numpy import array
import numpy as np
import cv2
import glob
i = 0
R = 0.9
Q = 0.005
A = 1
C = 1
P = 1
xh = 0
rssi1 = 0
rssi2 = 0
rssi3 = 0
read1 = False
read2 = False
read3 = False

def readData(file):
    data = []
    for line in file.readlines():
        temp = [value for value in line.split()]
        data.append( temp )
    file.close()

    data = array(data)
    data = str(data.tolist())
    data = data.replace("[", '').replace("]", '').replace(" ","").replace("'","")
    data = list(map(int, data.split(',')))
    return data

def kalman(xhat,z,P,A,C,R,Q):
    #estimar
    xhat = A*xhat
    P = A*P*A
    #corregir
    K = P*C/(C*P*C+R)
    P = (1-K*C)*P
    xhat = xhat+K*(z-C*xhat)
    return xhat

def callback(bt_addr, rssi, packet, additional_info):
    global i,xh,rssi1,rssi2,rssi3,read1,read2,read3

    if (rssi == 0):
        dist = -1.0

    ratio = rssi*1.0/packet.tx_power
    #if(i == 0):
    #    xh = ratio
    #xh = kalman(xh,ratio,P,A,C,R,Q)

    dist = (0.89976)*pow(xh,7.7095)+0.111

    if(bt_addr == "b4:99:4c:4f:97:50"):
        #print("1:  addr: %s,minor %d"%(bt_addr,packet.minor))
        rssi1 = rssi
        read1 = True
    if(bt_addr == "b4:99:4c:4f:4d:58"):
        #print("2:  addr: %s,minor %d"%(bt_addr,packet.minor))
        rssi2 = rssi
        read2 = True
    if(bt_addr == "b4:99:4c:4f:9a:24"):
        #print("3:  addr: %s,minor %d"%(bt_addr,packet.minor))
        rssi3 = rssi
        read3 = True

    if((read1 == True)&(read2 == True)&(read3==True)):
        #print("%d,%d,%d"%(rssi1,rssi2,rssi3))
        data = np.array([rssi1,rssi2,rssi3])
        data = data.reshape(1,-1)
        predict = knn.predict(data)
        print(predict)
        k = cv2.waitKey(100)
        read1 = False
        read2 = False
        read3 = False
        i = i+1



# scan for all iBeacon advertisements from beacons with the specified uuid
#1: b4:99:4c:4f:97:50  2:b4:99:4c:4f:4d:58   3:b4:99:4c:4f:9a:24
scanner = BeaconScanner(callback,device_filter=IBeaconFilter(uuid="e2c56db5-dffb-48d2-b060-d0f5a71096e0"))

X_data = []
files = glob.glob ("*.png")
for myFile in files:
    print(myFile)
    image = cv2.imread (myFile)
    X_data.append (image)

cv2.imshow('ims',X_data[3])
trainFile = open( "TrainData.txt" );
outFile = open("TrainOut.txt")
TrainIn = readData(trainFile)
TrainOut = readData(outFile)
print(len(TrainOut))
X = np.zeros((int(len(TrainIn)/3),3))
for i in range(0,int(len(TrainIn)/3)):
    X[i,0] = TrainIn[i*3]
    X[i,1] = TrainIn[i*3+1]
    X[i,2] = TrainIn[i*3+2]

Y = np.zeros(len(TrainOut))
for i in range(0,int(len(TrainOut))):
    Y[i] = TrainOut[i]
print(X[1,:])
print(len(TrainOut))
knn = KNeighborsClassifier(n_neighbors = 20)
knn.fit(X, Y)
print('Accuracy of K-NN classifier on training set: {:.2f}'.format(knn.score(X, Y)))

while(1):
    scanner.start()

    time.sleep(5)


scanner.stop()
