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

def stub_write( fdi ):
	board.write('en_proc',0)	
	f=open(fdi)
	for line in f:
		print line.strip()
		data0 = line.split(' ')[0]
		data1 = line.split(' ')[1]
		add0 = line.split(' ')[2]
		add1 = line.split(' ')[3].strip()
		#print data0,data1,add0,add1
#lowest 16 bits of data0 and lowest 20 bits of data1 are meaningful stub inputs		
#combine the 36-bit stub inputs and split them into two 18-bit pieces
#write each 18-bit piece into top 18 bits of a 32-bit wide fifo
		stubin = data0[4:8]+data1[3:8]	
		data_in0 = (bin(int(stubin,16))[2:].zfill(36))[0:18]+'00000000000000'# in binary 
		data_in1 = (bin(int(stubin,16))[2:].zfill(36))[18:36]+'00000000000000'# in binary
		g=open('AddrTable.dat')	
		for add in g:
			if add0 in add:
				print '0',hex(int(data_in0,2))
				board.write(add.split(' ')[0].strip(),(int(data_in0,2)))
			if add1 in add.strip():
				board.write(add.split(' ')[0].strip(),int(data_in1,2))
				print '1',hex(int(data_in1,2))

def track_read():
	print hex(board.read('track_out0'))
	print hex(board.read('track_out1'))
	print hex(board.read('track_out2'))
	print hex(board.read('track_out3'))
		
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

#if 'stub' in sys.argv:
#	print 'STUB'
#	stub_write()
	
#if 'track' in sys.argv:
#	print 'TRACK'
#	track_read()

#if 'tracklet' in sys.argv:
#	print 'TRACKLET'
#	tracklet_read()

print	
print 'Write Stub link1'
stub_write('../../TrackletProject/VC709/project/skim_D3/InputStubs_IL1_D3_02_in2.dat')

print 'Write Stub link2'
stub_write('../../TrackletProject/VC709/project/skim_D3/InputStubs_IL2_D3_02_in2.dat')

print 'Write Stub link3'
stub_write('../../TrackletProject/VC709/project/skim_D3/InputStubs_IL3_D3_02_in2.dat')

print
print 'Turn on enable signal'
board.write('en_proc',1)

#print 'Read tracks'
#track_read()
