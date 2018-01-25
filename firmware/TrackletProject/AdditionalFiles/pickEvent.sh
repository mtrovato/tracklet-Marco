#!/bin/bash

source /opt/rh/devtoolset-2/enable;source /home/jchavesb/root-6.06.00/bin/thisroot.sh
python firmware/TrackletProject/AdditionalFiles/picker.py $*
cd fpga_emulation
if [ "$1" == "all" ] 
then
    make;./fpga ../pickedEvent.txt 100 0
else
    make;./fpga ../pickedEvent.txt $# 0
fi

cd -
if [ "$2" == "D4D6" ]
then
	python firmware/TrackletProject/AdditionalFiles/input_combinerD4D6.py
else
	python firmware/TrackletProject/AdditionalFiles/input_combiner.py
fi
mv test_*.txt firmware/TrackletProject/AdditionalFiles/
