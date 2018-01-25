import sys

def CleanMem(fname):
  fin = open(fname+".dat","r")
  fout = open(fname+"_clean.dat","w")
  
  BX = 0
  event = 0
  prevBX = 0
  prevevent = 1 
  nentry = 0
  finnum = 0
  totnum = 0
  diff = 0
  string = []
  datatmp1 = 0
  datatmp2 = 0
  data = 0

  #---------------------------------------
  # total number of entries for the memory 
  # depends on TMUX and which memory!
  # numbers here are for TMUX = 6
  #---------------------------------------
  if "_AS_" in fname: 
    totnum = 33
  if "_FM_" in fname:
    totnum = 2 

  #---------------------------------------
  # parse the file  
  #---------------------------------------
  for line in fin:
    line = line.rstrip('\n')

    if "Event : " in line: # figure BX and Event num 
      line = line.split(" ")
      BX = line[2]
      event = line[5]
      nentry = 1
 
    else: # for each event reformat string for easier reading into vivado
      line = line.split("|")
      event = event
      newline = line[0].split(" ") 
      fout.write(BX+" "+event+" ")  # on each line print BX and event num
      nentry = int(newline[0],16)+1 # convert the number of entries from hex. to dec.
     
      if (nentry > totnum): 
        continue
 
      #---------------------------------------
      # format depending on which memory
      #---------------------------------------
      if "_AS_" in fname:
        string = newline[1]+line[1]+line[2]+line[3]
      if "_FM_" in fname:
        string = line[1]+line[2]+line[3]+line[4]
      #data = hex(int(string,2))
      
      if "_AS_" in fname: # AllStubs
        fout.write(str(nentry)+" "+string+"\n")
      if "_FM_" in fname: # FullMatch
        fout.write(line[0]+" "+line[1]+line[2]+line[3]+line[4]+"\n")

      diff = totnum-nentry

    #print("Event = %s : PrevEvent = %s" % (event, prevevent))
    #print("Nentry = %i : TotNum = %i" % (nentry, totnum))
    if (event != prevevent) and (nentry < totnum):
        for i in range (0,diff):
          fout.write(str(prevBX)+" "+str(prevevent)+" 0 00000000000000000000000000000000000000000000000000 \n")
        if (prevBX != 0): 
          fout.write(str(prevBX)+" "+str(prevevent)+" 0 00000000000000000000000000000000000000000000000000 \n")
          fout.write(str(prevBX)+" "+str(prevevent)+" 0 00000000000000000000000000000000000000000000000000 \n")
        fout.write(line[2]+" "+line[5]+" 0 11111111111111111111111111111111111111111111111111 \n")

    prevevent = event
    prevBX = BX

if __name__ == "__main__":

  filename = ""

  if len(sys.argv) == 1: 
    print("Invalid usage! Correct usage is: python clean_input.py [InputFile]")
    sys.exit()
  if len(sys.argv) > 1:
    if len(sys.argv) > 2: 
      print("Invalid usage! Correct usage is: python clean_input.py [InputFile]")
      sys.exit()
    else: 
      filename = sys.argv[1]

  CleanMem(filename)
  print("Clean file: %s_clean.dat" % filename)
