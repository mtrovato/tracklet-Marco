# Test Bench Instructions

## Working version of firmware uses:
  * Vivado 2016.1

## Tcl instructions for making project: 

The project can be generated from a Tcl script without the need of committing the xpr file. 

	1. In the Vivado Tcl console, change directory to the area
	cd firmware/TrackletProject/TestBench
	2. In the Vivado Tcl console, source the script
	source ./testbench.tcl

## Remaking the Tcl file

If new sources are added or general project changes are made, remake the Tcl script. This can be done from the Vivado client: File-> Write Project Tcl ... 

Replace in the Tcl file

	create_project project ./project -part xc7vx690tffg1927-2 ->
	create_project project ./project -part xc7vx690tffg1927-2 -force

## Running the simulation

Use the python script `clean_input.py` (in the InFiles directory) to change memories (FILENAME) from the emulation to the format for the firmware input. Or run for multiple inputs with the bash script: `./run_cleaning.sh`.  

Then in simulation.v set the parameters like size and number of inputs/outputs
and the input file directory path. Set input file names in input.v . 

Output files are written to the directory OutFiles. 





