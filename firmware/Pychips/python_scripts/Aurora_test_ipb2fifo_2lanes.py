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
dataout11 = board.read("rxdata3_pphi")
dataout12 = board.read("rxdata4_pphi")
print "-> aurora output :", hex(dataout11)," ",hex(dataout12)

print
print "-> read aurora mphi output :"
dataout21 = board.read("rxdata3_mphi")
dataout22 = board.read("rxdata4_mphi")
print "-> aurora output :", hex(dataout21)," ",hex(dataout22)

'''print
print "write to tx_fifo_pphi :"
#[26:0]--tdata	[31:28]--tkeep	[27]--tlast
board.write("tx_fifo_pphi",0xf1c6cafe)	#tdata = 0x1c6cafe, tkeep = 4b1111, tlast = 1b0
board.write("tx_fifo_pphi",0xf9a3babe)	#tdata = 0x1a3babe, tkeep = 4b1111, tlast = 1b1
# data package sent is : 0x1

print
print "write to tx_fifo_mphi :"

board.write("tx_fifo_mphi",0xff060614)	#tdata = 0x0614, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_mphi",0xff06fead)	#tdata = 0xfead, tkeep = 0b11, tlast = 0b0
board.write("tx_fifo_mphi",0xff03e47a)	#tdata = 0xe47a, tkeep = 0b01, tlast = 0b1
'''

stat1=0xf0000000  #link status part of the input; tkeep=1111, tlast=0
stat2=0xf8000000  #link status part of the input; tkeep=1111, tlast=1

print

print "writing to tx_fifo ..."

ndata = 10
for i in range(ndata):

	random=binascii.b2a_hex(os.urandom(7)) # 7 bytes random string from system
	random2=binascii.b2a_hex(os.urandom(7))
	# convert hex string to long and then convert to binary. Take the lower 54 bits to be the data and seperate the data into two 27-bit pieces. 
	do1=bin(int(random,16))[0:27]
	do2=bin(int(random,16))[27:54]
	do3=bin(int(random2,16))[0:27]
	do4=bin(int(random2,16))[27:54]
	# output data via ipbus is 32 bits wide. Lower 27 bits are for data and top 5 bits are for tkeep and tlast
	# A 54 bits word is sent 
	out_1=stat1+int(do1,2)          # combine status and data parts
	out_2=stat2+int(do2,2)          # combine status and data parts
	#write to tx_fifo_pphi
	board.write("tx_fifo_pphi",out_1)	
	board.write("tx_fifo_pphi",out_2)	

	out_3=stat1+int(do3,2)
	out_4=stat2+int(do4,2)
	#write to tx_fifo_mphi
	board.write("tx_fifo_mphi",out_3)
	board.write("tx_fifo_mphi",out_4)

	#print the last data sent to compare with the last readout
	if i==range(ndata)[-1]:
		print "last data written to tx_fifo_pphi :"
		print "DO piece 1 :", hex(out_1)
		print "DO piece 2 :", hex(out_2)
		print 
		print "last data written to tx_fifo_mphi :"
		print "DO piece 1 :", hex(out_3)
		print "DO piece 2 :", hex(out_4)
######################################################################################

print
print "enable link ... "
board.write("link_en",0x00000003,0)

print
print "-> read aurora pphi output :"
dataout11 = board.read("rxdata3_pphi")
dataout12 = board.read("rxdata4_pphi")
print "-> aurora output :", hex(dataout11)," ",hex(dataout12)

print
print "-> read aurora mphi output :"
dataout21 = board.read("rxdata3_mphi")
dataout22 = board.read("rxdata4_mphi")
print "-> aurora output :", hex(dataout21)," ",hex(dataout22)

print
print "-> Latency measurement : "
timerout_p2m = board.read("timer_p2m")
timerout_m2p = board.read("timer_m2p")
print "p2m : ", timerout_p2m
print "m2p : ", timerout_m2p

