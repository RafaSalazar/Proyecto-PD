import time
from beacontools import BeaconScanner, IBeaconFilter

def callback(bt_addr, rssi, packet, additional_info):

    if (rssi == 0):
        dist = -1.0
    ratio = rssi*1.0/packet.tx_power
    dist = (0.89976)*pow(xh,7.7095)+0.111

    print("bt_addr: %s      " %bt_addr)
    print("rssi: %d     " %rssi)
    print("Distance %d      ",dist)
    print("tx Power: %s \n" %packet.tx_power)


#1: b4:99:4c:4f:97:50  2:b4:99:4c:4f:4d:58   3:b4:99:4c:4f:9a:24
scanner = BeaconScanner(callback,device_filter=IBeaconFilter(uuid="e2c56db5-dffb-48d2-b060-d0f5a71096e0"))
print("Zona 5")
while(i<300):
    scanner.start()
    time.sleep(5)
scanner.stop()
