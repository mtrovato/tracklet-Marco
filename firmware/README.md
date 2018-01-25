# Firmware

## Working version of CTP7 master project:
 * Vivado 2016.1

## Tcl Instructions for CTP7 project:

The project can be generated from a Tcl script without the need of committing the xpr file.

	1. In the Vivado Tcl Console, change directory to the CTP7 area
	cd firmware/TrackletProject/CTP7
	or change directory to InputDTC area for InputDTC project
	cd firmware/InputDTC
	2. In the Vivado Tcl Console, source the script
	source ./project.tcl

### Remaking Tcl file
If new sources are added or general project changes are made, remake the Tcl script. This can be done from the Vivado client: File-> Write Projet Tcl...

The resulting tcl file needs to be fixed to include the additional commands needed by the CTP7 project.

Replace:
	
	create_project project ./project -part xc7vx690tffg1927-2 -> create_project project ./project -part xc7vx690tffg1927-2 -force

Add before implementation (impl_2) definition (Tracklet project only):

	if {[file exists ~/.Xilinx/Vivado/strategies/aggressive\ explore.Vivado\ Implementation\ 2016.psg]} {
    		puts "Strategy file already exists."
	} else {
    		file copy $origin_dir/../AdditionalFiles/aggressive\ explore.Vivado\ Implementation\ 2016.psg ~/.Xilinx/Vivado/strategies/
	}

## Vivado simulation

Top level simulation module: ctp7_simulation.v
Before running simulation, change parameter USER_DIR in top simulation module to the full path of the directory where firmware/ sits. By default, simulation runs with D3D4 project using one track events. Uncomment relevant tracklet_processing module name in verilog_tigger_top.v and the corresponding input and outputs in input_sim.v and output_sim.v to run on other project configurations.
Simulation outputs are stored under USER_DIR/firmare/TrackletProject/AdditionalFiles/ with prefix "Output_".

## Tag history:
* JEC290816:
	* Half barrel project with full agreement for single tracks. 
	* First integration of disk modules back into master.
		* Bit sizes adjusted for unified modules.
	* Fitter inputs corrected for D3D4 project.
	* DRAMs for neighbor memories.
* JEC190716:
	* Merger in fitter optimized for timing.
		* New FIFOs included to cache the residuals.
	* Additional pipelining for timing.
	* Simplify ProjTransceiver.
		* No FIFOs used.
	* DRAMs used for StubsByLayers and Projection memories to neighbors.
	* New DTC firmware available.
		* Use memories for L3L4 and L5L6 instead of neighbor boards (this will be added later).
* JEC160616:
	* Debugging of alternative seeding layers.
	* Simplify MatchTransceiver.
		* Use FIFOs in simulation of links.
	* Track indices now included in final track.
* JEC160525:
	* Several improvements done for the half barrel project.
		* Transceivers expanded.
		* Input files for simulation organized.
		* Implementation setting "optimized".
	* Fit track positive sums to match documentation.
	* Tracklet index now included in matches.
* JEC160515:
	* New way to read memories for PR (maybe propagate to other modules).
	* Number of bits corrected in MC.
	* Extra delay for FM memories that come from neighbor.
	* PT expanded for D3D4.
	* Extra pipeline in FT lookup tables.
* JEC160503: 
	* Now simulating 3 sectors.
		* Use independent files for each sector.
	* DTC input is separate for each board.
		* Tools for RPC communication in the software repository. 
* JEC160420: 
	* FitTrack merger fixed.
	* MT latency corrected for reg_array.
	* RPC added for stub inputs.
* JEC160416: 
	* New VMRouter reader for Stubin memories based on which link they are coming from.
	* Working on 5 track events with TMUX=6.
		* Emulation code has a constant "maxstubslink" in FPGAInputLink.hh causing problems with input file generation.
	* Tracklet cuts fixed.
	* MT valid is undefined if all inputs are not defined. Working for D3 only. TO BE FIXED.
* JEC160328: 
	* Remove extra clock in double nested loops.
	* AllProjection memories now have an additional parameter since the write address has to be the tracklet index. 
		* Different bits for inner and outer layers.
	* Phi derivative is now signed in the projection calculation.
	* Prio_encoder for projections forced to only have 4 inputs. Change this if number of inputs changes.
* JEC160323: 
	* Half sector project added.
	* Fixed bit size bug in MatchTransceiver.
	* Projection length fixed to include Tracklet index.
    * Additional links included to transmit projections.
	* FullMatch memories with pipelining for merger.
		* Read enable bit used in FM memories.
	* Ripple reset with 2 bits for start/done.
* LS_160310:
	* Tagging update from Jorge ("Added 2 delays in ME to compensate for DRAM usage")
	* -->> This version gives 100% agreement for single tracks (w/o
      projections to neighboring sectors)!
* JEC160309: 
	* D3 only project.
	* Removed additional TrackletProjection modules.
	* MatchEngine bug fixed for multiple track events.
* LS_160308: 
	* Comparison tag to compare with LS_16038 tag in emulation.
	* -->> This tag had full agreement for events that only have 1 track (27/31 of the "single track" events), while for events with 2 tracks, the 2nd tracks was not found in simulation.
* JEC160305: 
	* D3 only project with expanded modules working towards half barrel project.
	* Generate statements for TrackletProjections modules.
	* 51 bits for Projections to go across links.
	* TMUX = 6
* JEC151204: Agreement before Christmas (Deprecated)
* JEC151019: Multiple tracks (Deprecated)
* v1_0: Initial tag (Deprecated)










