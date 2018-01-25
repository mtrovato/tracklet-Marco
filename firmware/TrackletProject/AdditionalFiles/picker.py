from itertools import groupby
import sys

print sys.argv
#f = open('fpga_emulation/evlist_ttbar_PU200_FLAT-newstubtune_100evtPart1.txt')
#f = open('fpga_emulation/evlist_ttbar_PU200_FLAT-newstubtune_100evtPart2.txt')
#f = open('fpga_emulation/evlist_ttbar_PU200_FLAT-newstubtune_100evt.txt')
f = open('fpga_emulation/skim_D4D6/skim_D4D6_ttbar200PU.txt')
#f = open('fpga_emulation/skim_D3D4_mu/evlist_D3D4_muplus_0-150_skim.txt')
#f = open('fpga_emulation/skim_D3D4_5/evlist_skim.txt')

g = open('pickedEvent.txt','w')
l = [list(group) for k, group in groupby(f.readlines(), lambda x: x == "Event: 0\n") if not k]
print len(l)

if 'all' in sys.argv:
    print "ALL"
    for ev in xrange(len(l)):
        g.write("Event: 0\n")
        for line in l[int(ev)]:
            g.write(line)
else:
    print sys.argv[1:]
    for ev in sys.argv[1:-1]:
        g.write("Event: 0\n")
        for line in l[int(ev)]:
            g.write(line)
