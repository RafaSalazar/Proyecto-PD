from ctypes import *
from ctypes.wintypes import *
from sys import exit
import subprocess
import time

for i in range(0,100):
    results = subprocess.check_output(["netsh", "wlan", "show", "interfaces"])
    results = results.decode("ascii") # needed in python 3
    signal = results[results.find("Signal"):results.find("Profile")]
    signal = signal[signal.find(':')+2:signal.find('%')]
    wifiSignal = int(signal)
    print(i,wifiSignal)
    time.sleep(0.1)
