import bluetooth
print("buscando...")
n = bluetooth.discover_devices(lookup_names = False)
print("find")
for addr in n:
    print(".%s" % (addr))
