from PyChipsUser import *
glibAddrTable = AddressTable("./glibAddrTable.dat")
import os
import time
########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening GLIB with IP", ipaddr
print "--=======================================--"
########################################
#chipsLog.setLevel(logging.DEBUG)    # Verbose logging (see packets being sent and received)


print
print "-> BOARD INFORMATION"
print "-> -----------------"

brd_char 	= ['w','x','y','z']
brd_char[0] = chr(glib.read("board_id_char1"))
brd_char[1] = chr(glib.read("board_id_char2"))
brd_char[2] = chr(glib.read("board_id_char3"))
brd_char[3] = chr(glib.read("board_id_char4"))
print "-> brd :",brd_char[0],brd_char[1],brd_char[2],brd_char[3]

sys_char 	= ['w','x','y','z']
sys_char[0] = chr(glib.read("sys_id_char1"))
sys_char[1] = chr(glib.read("sys_id_char2"))
sys_char[2] = chr(glib.read("sys_id_char3"))
sys_char[3] = chr(glib.read("sys_id_char4"))
print "-> sys :",sys_char[0],sys_char[1],sys_char[2],sys_char[3]

ver_major = glib.read("ver_major")
ver_minor = glib.read("ver_minor")
ver_build = glib.read("ver_build")
print "-> ver :", ver_major,".",ver_minor,".",ver_build
yy  = 2000+glib.read("firmware_yy")
mm  = glib.read("firmware_mm")
dd  = glib.read("firmware_dd")
print "-> date:", dd,"/",mm,"/", yy

#####################################################################
os.system('c:\python27\python glib_i2c_eeprom_read_eui.py')
#####################################################################


counter=[0x0,0x420c4146]
data1=[0xd,0x7fa4bb6b]
data2=[0x3,0x9f98bdbb]
data3=[0xc,0xbf90bf83]
data4=[0xc,0x7fe6117b]
data5=[0x2,0x5fe62aec]
data6=[0x1,0xafe640cb]

glib.write("R3_io_block_wd_data0",counter[1])
glib.write("R3_io_block_wd_data1",counter[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("R3_io_block_wd_data0",data1[1])
glib.write("R3_io_block_wd_data1",data1[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("R3_io_block_wd_data0",data2[1])
glib.write("R3_io_block_wd_data1",data2[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("R3_io_block_wd_data0",data3[1])
glib.write("R3_io_block_wd_data1",data3[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("R3_io_block_wd_data0",data4[1])
glib.write("R3_io_block_wd_data1",data4[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("R3_io_block_wd_data0",data5[1])
glib.write("R3_io_block_wd_data1",data5[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("R3_io_block_wd_data0",data6[1])
glib.write("R3_io_block_wd_data1",data6[0])
glib.write("R3_io_block_wr_link1",1)
glib.write("en_proc",1)
print "test",hex(glib.read("R3_layer_sort_link1_layer2_memory"))





