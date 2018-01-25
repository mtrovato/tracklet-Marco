from PyChipsUser import *
AddrTable = AddressTable("./AddrTable.dat")
import os
import time
import binascii
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
print "unset link reset..."
board.write("link_rst",0xfffffffe,0)
rst = board.read("link_rst")
print bin(rst)

#######################
print
print "check link live status before sending data :"
print
#live status
live_status1 = board.read("live_status_pphi")
print "-> aurora pphi live status :", bin(live_status1)
print
#live status
live_status2 = board.read("live_status_mphi")
print "-> aurora mphi live status :", bin(live_status2)
#########################

print
print "check output regs before sending data :"
print
print "-> read aurora pphi output :"
dataout11 = board.read("rxdata1_pphi")
dataout12 = board.read("rxdata2_pphi")
dataout13 = board.read("rxdata3_pphi")
dataout14 = board.read("rxdata4_pphi")
print "-> aurora output :", hex(dataout11)," ",hex(dataout12)," ",hex(dataout13)," ",hex(dataout14)

print
print "-> read aurora mphi output :"
dataout21 = board.read("rxdata1_mphi")
dataout22 = board.read("rxdata2_mphi")
dataout23 = board.read("rxdata3_mphi")
dataout24 = board.read("rxdata4_mphi")
print "-> aurora output :", hex(dataout21)," ",hex(dataout22)," ",hex(dataout23)," ",hex(dataout24)

print
print "write to tx_fifo_pphi :"
#[15:0]--tdata	[18:17]--tkeep	[16]--tlast
board.write("tx_fifo_pphi",0xff06cafe)	#tdata = 0xcafe, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_pphi",0xff06babe)	#tdata = 0xbabe, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_pphi",0xff064f6a)	#tdata = 0xbeaf, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_pphi",0xff058c2b)	#tdata = 0x8c2b, tkeep = 0b10, tlast = 0b1
# # data package sent is : 0xcafebabebeef12
# board.write("tx_fifo_pphi",0xfff6abcd)	#tdata = 0xabcd, tkeep = 0b11, tlast = 0b0
# board.write("tx_fifo_pphi",0xfff65678)	#tdata = 0x5678, tkeep = 0b11, tlast = 0b0
# board.write("tx_fifo_pphi",0xfff60cab)	#tdata = 0x0cab, tkeep = 0b11, tlast = 0b0
# board.write("tx_fifo_pphi",0xfff5deaf)	#tdata = 0xdeaf, tkeep = 0b10, tlast = 0b1
# # data package sent is : 0xabcd56780cabde

print
print "write to tx_fifo_mphi :"
#[15:0]--tdata	[18:17]--tkeep	[16]--tlast
board.write("tx_fifo_mphi",0xff061990)	#tdata = 0x1990, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_mphi",0xff060614)	#tdata = 0x0614, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_mphi",0xff06fead)	#tdata = 0xfead, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_mphi",0xff03e47a)	#tdata = 0xe47a, tkeep = 0b01, tlast = 0b1
#data package sent is : 0x19900614feadad
# board.write("tx_fifo_pphi",0xfff61357)	#tdata = 0x1357, tkeep = 0b11, tlast = 0b0
# board.write("tx_fifo_pphi",0xfff63d5e)	#tdata = 0x3d5e, tkeep = 0b11, tlast = 0b0
# board.write("tx_fifo_pphi",0xfff6fe3b)	#tdata = 0xfe3b, tkeep = 0b11, tlast = 0b0
# board.write("tx_fifo_pphi",0xfff7a9c0)	#tdata = 0xa9c0, tkeep = 0b11, tlast = 0b1
# # data package sent is : 0x13573d5efe3ba9c0

# print
# print "enable link ... "
# board.write("link_en",0x00000003,0)

######################################################################################
# generate random input data and write to the fifo for eyescan
# print "************************************************"
# print "*****************           ********************"
# print "*************                   ****************"
# print "*********                            ***********"
# print "*****                                     ******"
# print "**                                            **"
# print "**                                            **"
# print "*****                                     ******"
# print "*********                            ***********"
# print "*************                   ****************"
# print "*****************           ********************"
# print "************************************************"

stat1=0xff060000  #link status part of the input; tkeep=11, tlast=0
stat2=0xff050000  #link status part of the input; tkeep=10, tlast=1

for i in range(10):

	random1=binascii.b2a_hex(os.urandom(2)) # 2 bytes random string from system
	random2=binascii.b2a_hex(os.urandom(2)) # 2 bytes random string from system
	random3=binascii.b2a_hex(os.urandom(2)) # 2 bytes random string from system
	random4=binascii.b2a_hex(os.urandom(2)) # 2 bytes random string from system

	out_1=stat1+int(random1,16)          # combine status and data parts, int() convert string to long
	out_2=stat1+int(random2,16)          # combine status and data parts, int() convert string to long
	out_3=stat1+int(random3,16)          # combine status and data parts, int() convert string to long
	out_4=stat2+int(random4,16)          # combine status and data parts, int() convert string to long

	board.write("tx_fifo_pphi",out_1)	
	board.write("tx_fifo_pphi",out_2)	
	board.write("tx_fifo_pphi",out_3)	
	board.write("tx_fifo_pphi",out_4)	
######################################################################################

# print
# print "-> read aurora mphi output :"
# readback_mphi = board.read("rx_fifo_mphi")
# print "-> readout :", hex(readback_mphi)
# live status
# live_status_mphi = board.read("live_status_mphi")
# print "-> aurora live status :", bin(live_status_mphi)

# print
# print "-> read aurora pphi output :"
# readback_pphi = board.read("rx_fifo_pphi")
# print "-> readout :", hex(readback_pphi)
# live status
# live_status_pphi = board.read("live_status_pphi")
# print "-> aurora live status :", bin(live_status_pphi)

print
print "enable link ... "
board.write("link_en",0x00000003,0)

print
print "-> read aurora pphi output :"
dataout11 = board.read("rxdata1_pphi")
dataout12 = board.read("rxdata2_pphi")
dataout13 = board.read("rxdata3_pphi")
dataout14 = board.read("rxdata4_pphi")
print "-> aurora output :", hex(dataout11)," ",hex(dataout12)," ",hex(dataout13)," ",hex(dataout14)

print
print "-> read aurora mphi output :"
dataout21 = board.read("rxdata1_mphi")
dataout22 = board.read("rxdata2_mphi")
dataout23 = board.read("rxdata3_mphi")
dataout24 = board.read("rxdata4_mphi")
print "-> aurora output :", hex(dataout21)," ",hex(dataout22)," ",hex(dataout23)," ",hex(dataout24)

print
print "-> Latency measurement : "
timerout_p2m = board.read("timer_p2m")
timerout_m2p = board.read("timer_m2p")
print "p2m : ", timerout_p2m
print "m2p : ", timerout_m2p

