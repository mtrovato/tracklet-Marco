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
#chipsLog.setLevel(logging.DEBUG)    # Verbose logging (see packets being sent and received)

def stub_write():
	board.write('en_proc',0)	
	f=open('data_in2.dat')
	for line in f:
	 print line.strip()
	 data0 = line.split(' ')[0]
	 data1 = line.split(' ')[1]
	 add0 = line.split(' ')[2]
	 add1 = line.split(' ')[3].strip()
	 print data0,data1,add0,add1
	 g=open('AddrTable.dat')	
	 for add in g:
	  if add0 in add:
	   print '0',hex(int(data0,16))
	   board.write(add.split(' ')[0].strip(),(int(data0,16)))
	  if add1 in add.strip():
	   board.write(add.split(' ')[0].strip(),int(data1,16))
	   print '1',hex(int(data1,16))
	board.write('en_proc',1)
	sleep(1)
	board.write('en_proc',0)

def track_read():
	print hex(board.read('track_out0'))
	
	
def tracklet_read():
	f = open('tracklets.txt','w')
	t1 = board.blockRead('tracklet_L1L2_1',2048)
	t2 = board.blockRead('tracklet_L1L2_2',2048)
	t1 = [hex(x)[2:-1] for x in t1]
	t2 = [hex(x)[2:-1] for x in t2]
	tr1 = []
	tr2 = []
	for x in t1:
		while len(x) < 8:
			x = '0'+x
		tr1.append(x)
	for x in t2:
		while len(x) < 6:
			x = '0'+x
		tr2.append(x)
	t = [y+x for x,y in zip(tr1,tr2) if y+x != '00000000000000']
	for x in t:
		f.write('"'+x+'",')
		#print x
	
	
##############################################

if 'stub' in sys.argv:
	print 'STUB'
	stub_write()
	
if 'track' in sys.argv:
	print 'TRACK'
	track_read()

if 'tracklet' in sys.argv:
	print 'TRACKLET'
	tracklet_read()
	
#print board.read('link3_data0')
