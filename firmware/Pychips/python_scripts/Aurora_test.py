from PyChipsUser import *
AddrTable = AddressTable("./AddrTable.dat")
import os
import time
########################################
# IP address
########################################
f = open('./ipaddr_vc707.dat', 'r')
ipaddr = f.readline()
f.close()
board = ChipsBusUdp(AddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening Board with IP", ipaddr
print "--=======================================--"
########################################
#chipsLog.setLevel(logging.DEBUG)    # Verbose logging (see packets being sent and received)

#testword = 0xaaaa5555


data1_pphi = 0x5678beef
data2_pphi = 0xcafebabe
data3_pphi = 0x12345678

data1_mphi = 0xdeadbeef
data2_mphi = 0xabcd7890
data3_mphi = 0x19900614

print 
print "reset link..."
board.write("link_rst",0xffffffff,0)
rst = board.read("link_rst")
board.write("link_en",0x00000000,0)  #set enable = 0
print bin(rst) 

print
print "-> Set loopback regs"
board.write("loopback_pphi",0x00000000,0)
board.write("loopback_mphi",0x00000000,0)

lbp = board.read("loopback_pphi")
lbm = board.read("loopback_mphi")
print bin(lbp), " ", bin(lbm)

print
print "-> write data to registers :"
print "-> write to pphi data registers : ", hex(data1_pphi)," ",hex(data2_pphi)," ",hex(data3_pphi)
board.write("txdata1_pphi",data1_pphi,0)
board.write("txdata2_pphi",data2_pphi,0)
board.write("txdata3_pphi",data3_pphi,0)

print "-> write to mphi data registers : ", hex(data1_mphi)," ",hex(data2_mphi)," ",hex(data3_mphi)
board.write("txdata1_mphi",data1_mphi,0)
board.write("txdata2_mphi",data2_mphi,0)
board.write("txdata3_mphi",data3_mphi,0)

print 
print "check input regs: "
input1_pphi = board.read("txdata1_pphi")
input2_pphi = board.read("txdata2_pphi")
input3_pphi = board.read("txdata3_pphi")
input1_mphi = board.read("txdata1_mphi")
input2_mphi = board.read("txdata2_mphi")
input3_mphi = board.read("txdata3_mphi")

print "pphi input regs : "
print hex(input1_pphi)
print hex(input2_pphi)
print hex(input3_pphi)
print "mphi input regs : "
print hex(input1_mphi)
print hex(input2_mphi)
print hex(input3_mphi)

#######################
print
print "check output regs before sending data :"
print
print "-> read aurora pphi output :"
dataout11 = board.read("rxdata1_pphi")
dataout12 = board.read("rxdata2_pphi")
dataout13 = board.read("rxdata3_pphi")
print "-> aurora output :", hex(dataout11)," ",hex(dataout12)," ",hex(dataout13)

print
print "-> read aurora pphi status :"
status11 = board.read("rxstat1_pphi")
status12 = board.read("rxstat2_pphi")
status13 = board.read("rxstat3_pphi")
#live status
live_status1 = board.read("live_status_pphi")
print "-> aurora status :", bin(status11)," ", bin(status12)," ",bin(status13)
print "-> aurora live status :", bin(live_status1)

print
print "-> read aurora mphi output :"
dataout21 = board.read("rxdata1_mphi")
dataout22 = board.read("rxdata2_mphi")
dataout23 = board.read("rxdata3_mphi")
print "-> aurora output :", hex(dataout21)," ",hex(dataout22)," ",hex(dataout23)

print
print "-> read aurora mphi status :"
status21 = board.read("rxstat1_mphi")
status22 = board.read("rxstat2_mphi")
status23 = board.read("rxstat3_mphi")
#live status
live_status2 = board.read("live_status_mphi")
print "-> aurora status :", bin(status21)," ", bin(status22)," ",bin(status23)
print "-> aurora live status :", bin(live_status2)
#########################

print 
print "unset link reset..."
board.write("link_rst",0xfffffffe,0)
rst = board.read("link_rst")
print bin(rst)

print
print "set enable "
board.write("link_en",0x00000003,0)

print
print "-> read aurora pphi output :"
dataout11 = board.read("rxdata1_pphi")
dataout12 = board.read("rxdata2_pphi")
dataout13 = board.read("rxdata3_pphi")
print "-> aurora output :", hex(dataout11)," ",hex(dataout12)," ",hex(dataout13)

print
print "-> read aurora pphi status :"
status11 = board.read("rxstat1_pphi")
status12 = board.read("rxstat2_pphi")
status13 = board.read("rxstat3_pphi")
#live status
live_status1 = board.read("live_status_pphi")
print "-> aurora status :", bin(status11)," ", bin(status12)," ",bin(status13)
print "-> aurora live status :", bin(live_status1)

print
print "-> read aurora mphi output :"
dataout21 = board.read("rxdata1_mphi")
dataout22 = board.read("rxdata2_mphi")
dataout23 = board.read("rxdata3_mphi")
print "-> aurora output :", hex(dataout21)," ",hex(dataout22)," ",hex(dataout23)

print
print "-> read aurora mphi status :"
status21 = board.read("rxstat1_mphi")
status22 = board.read("rxstat2_mphi")
status23 = board.read("rxstat3_mphi")
#live status
live_status2 = board.read("live_status_mphi")
print "-> aurora status :", bin(status21)," ", bin(status22)," ",bin(status23)
print "-> aurora live status :", bin(live_status2)

print "-> Latency measurement : "
timerout_p2m = board.read("timer_p2m")
timerout_m2p = board.read("timer_m2p")
print "p2m : ", timerout_p2m
print "m2p : ", timerout_m2p