from PyChipsUser import *
from time import sleep
AddrTable = AddressTable("./AddrTable.dat")
import os,sys

########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
print ipaddr
f.close()
board = ChipsBusUdp(AddrTable, ipaddr, 50001)
chipsLog.setLevel(logging.DEBUG)    # Verbose logging (see packets being sent and received)
