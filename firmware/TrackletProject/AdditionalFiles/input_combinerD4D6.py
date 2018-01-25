for x in [1,2,3]:
        g1=open('test_D4_'+str(x)+'.txt','w')
        g2=open('test_D5_'+str(x)+'.txt','w')
	g3=open('test_D6_'+str(x)+'.txt','w')
        #for s in xrange(26):
        for s in [1]:
            sc = str(s+x)
            if len(sc) == 1:
                sc = '0' + sc            
            #print sc
            f1=open('fpga_emulation/InputStubs_IL1_D4_'+sc+'_in2.dat')
            f2=open('fpga_emulation/InputStubs_IL2_D4_'+sc+'_in2.dat')
            f3=open('fpga_emulation/InputStubs_IL3_D4_'+sc+'_in2.dat')
            f4=open('fpga_emulation/InputStubsDiskF_IL1_D5_'+sc+'_in2.dat')
            f5=open('fpga_emulation/InputStubsDiskF_IL2_D5_'+sc+'_in2.dat')
            f6=open('fpga_emulation/InputStubsDiskF_IL3_D5_'+sc+'_in2.dat')
            f7=open('fpga_emulation/InputStubsDiskF_IL1_D6_'+sc+'_in2.dat')
            f8=open('fpga_emulation/InputStubsDiskF_IL2_D6_'+sc+'_in2.dat')
            f9=open('fpga_emulation/InputStubsDiskF_IL3_D6_'+sc+'_in2.dat')
           
            for l1,l2,l3 in zip(f1,f2,f3):
                s= l1.strip().replace('51000003 51000007','')+l2.strip().replace('51000003 51000007','')+l3.replace('51000003 51000007','')
                g1.write(s)
        
            for l1,l2,l3 in zip(f4,f5,f6):
                s= l1.strip().replace('51000003 51000007','')+l2.strip().replace('51000003 51000007','')+l3.replace('51000003 51000007','')
                g2.write(s)

            for l1,l2,l3 in zip(f7,f8,f9):
                s= l1.strip().replace('51000003 51000007','')+l2.strip().replace('51000003 51000007','')+l3.replace('51000003 51000007','')
                g3.write(s)
