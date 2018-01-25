def combine():
	f1=open('/home/Jorge/work/InputFiles/InputStubs_IL1_D3_02_in2.dat')
	f2=open('/home/Jorge/work/InputFiles/InputStubs_IL2_D3_02_in2.dat')
	f3=open('/home/Jorge/work/InputFiles/InputStubs_IL3_D3_02_in2.dat')
	
	g=open('test.txt','w')
	for l1,l2,l3 in zip(f1,f2,f3):
	    s= l1.strip().replace('51000003 51000007','')+l2.strip().replace('51000003 51000007','')+l3.replace('51000003 51000007','')
	    g.write(s)
	f1=open('/home/Jorge/work/InputFiles/InputStubs_IL1_D3_03_in2.dat')
	f2=open('/home/Jorge/work/InputFiles/InputStubs_IL2_D3_03_in2.dat')
	f3=open('/home/Jorge/work/InputFiles/InputStubs_IL3_D3_03_in2.dat')
	for l1,l2,l3 in zip(f1,f2,f3):
	    s= l1.strip().replace('51000003 51000007','')+l2.strip().replace('51000003 51000007','')+l3.replace('51000003 51000007','')
	    g.write(s)

def poke_this(link):
	#f=open('input_100evt.dat')
	f=open('test.txt')
	g=open('link_input_%d.sh' %link,'w')
	for line in f:
		if link == 1:
			g.write('mpoke 0x62012000 0x'+line.split(' ')[0]+'\nmpoke 0x62012004 0x'+line.split(' ')[1].strip()+'\n')
		elif link ==2:
                        g.write('mpoke 0x62012008 0x'+line.split(' ')[2]+'\nmpoke 0x6201200C 0x'+line.split(' ')[3].strip()+'\n')
		elif link ==3:
			g.write('mpoke 0x62012010 0x'+line.split(' ')[4]+'\nmpoke 0x62012014 0x'+line.split(' ')[5].strip()+'\n')


poke_this(1)
poke_this(2)
poke_this(3)
