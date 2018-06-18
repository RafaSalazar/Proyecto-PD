import numpy as np
import cv2
import time

def mapCirToRect(Ws,Hs,Wd,Hd,R1,R2,Cx,Cy):
    map_x = np.zeros((Hd,Wd),np.float32)
    map_y = np.zeros((Hd,Wd),np.float32)
    for y in range(0,(Hd-1)):
        for x in range(0,(Wd-1)):
            r = (float(y)/float(Hd))*(R2-R1)+R1
            theta = (float(x)/float(Wd))*2.0*np.pi
            xS = Cx+r*np.sin(theta)
            yS = Cy+r*np.cos(theta)
            map_x.itemset((y,x),int(xS))
            map_y.itemset((y,x),int(yS))
    return map_x, map_y

def remapImage(img,xmap,ymap):
    result = cv2.remap(img,xmap,ymap,cv2.INTER_LINEAR)
    return result


cap = cv2.VideoCapture("vid.mp4")
ret, img = cap.read()
Hs, Ws = img.shape[:2]

cmaxx = 322
cmaxy = 190
cminx = cmaxx
cminy = cmaxy
min = 52
max = 103

Cx = cmaxx
Cy = cmaxy
R1 = min
R2 = max
Wd = int(round(float(R2) * 2.0 * np.pi))
Hd = int((R2-R1))

print("MAPEANDO")
xmap,ymap = mapCirToRect(Ws,Hs,Wd,Hd*2,R1,R2,Cx,Cy)
print("ok")

while(cap.isOpened()):
    ret, img = cap.read()
    if ret == True:
        result = remapImage(img,xmap,ymap)
        cv2.imshow('Correction',result)
        cv2.circle(img,(cmaxx,cmaxy),max,(0,255,0),2)
        cv2.circle(img,(cmaxx,cmaxy),2,(0,0,255),3)
        cv2.circle(img,(cminx,cminy),min,(0,255,0),2)
        cv2.circle(img,(cminx,cminy),2,(0,0,255),3)
        cv2.imshow('Imagen sin correccion',img)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    else:
        break

cap.release()
cv2.destroyAllWindows()
