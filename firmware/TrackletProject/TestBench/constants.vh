// Include this file and define all the constants here

// Latency for the optical links. This number controls the done
// signal in the transceivers.
`define LINK_LATENCY 90

// Time Multiplexing factor * clock frequency
// Currently 6 @ 240 MHz
`define tmux 36

// Depth of Memories
`define MEM_SIZE 5

// Tracklet constants
`define TC_L1L2_krA 20'sd981
`define TC_L1L2_krB 20'sd1515
`define TC_L3L4_krA 20'sd2155
`define TC_L3L4_krB 20'sd2918
`define TC_L5L6_krA 20'sd3772
`define TC_L5L6_krB 20'sd4599
// Tracklet projection constants
// Phi bits by layer
`define PHI_L1 14
`define PHI_L2 14
`define PHI_L3 14
`define PHI_L4 17
`define PHI_L5 17
`define PHI_L6 17
// Z bits by layer
`define  Z_L1 12
`define  Z_L2 12
`define  Z_L3 12
`define  Z_L4 8
`define  Z_L5 8
`define  Z_L6 8
// R bits by layer
`define  R_L1 7
`define  R_L2 7
`define  R_L3 7
`define  R_L4 8
`define  R_L5 8
`define  R_L6 8
// Phi derivative bits by layer
`define PHID_L1 7
`define PHID_L2 7
`define PHID_L3 7
`define PHID_L4 8
`define PHID_L5 8
`define PHID_L6 8
// Z derivative bits by layer
`define  ZD_L1 8
`define  ZD_L2 8
`define  ZD_L3 8
`define  ZD_L4 7
`define  ZD_L5 7
`define  ZD_L6 7
// RPROJ Constants
`define  RPROJ_L1 980
`define  RPROJ_L2 1514
`define  RPROJ_L3 2154
`define  RPROJ_L4 2918
`define  RPROJ_L5 3771
`define  RPROJ_L6 4599
`define  ZPROJ_F1 2341
`define  ZPROJ_F2 2778
`define  ZPROJ_F3 3294
`define  ZPROJ_F4 3917
`define  ZPROJ_F5 4651

// Match Calculator Constants
// Shifts for corrections
`define MC_k1ABC_INNER 2
`define MC_k2ABC_INNER 4
`define MC_k1ABC_OUTER 0
`define MC_k2ABC_OUTER 9
// Phi residual cuts
`define MC_phi_L1L2_L3 868
`define MC_phi_L1L2_L4 1793
`define MC_phi_L1L2_L5 1388
`define MC_phi_L1L2_L6 1138
`define MC_phi_L3L4_L1 1810
`define MC_phi_L3L4_L2 1172
`define MC_phi_L3L4_L5 991
`define MC_phi_L3L4_L6 813
`define MC_phi_L5L6_L1 1810
`define MC_phi_L5L6_L2 1172
`define MC_phi_L5L6_L3 824
`define MC_phi_L5L6_L4 1281
// Z residual cuts
`define MC_z_L1L2_L3 9
`define MC_z_L1L2_L4 53
`define MC_z_L1L2_L5 53
`define MC_z_L1L2_L6 53
`define MC_z_L3L4_L1 249
`define MC_z_L3L4_L2 249
`define MC_z_L3L4_L5 249
`define MC_z_L3L4_L6 249
`define MC_z_L5L6_L1 249
`define MC_z_L5L6_L2 249
`define MC_z_L5L6_L3 249
`define MC_z_L5L6_L4 249
// Z factor cuts
`define MC_zfactor_INNER 0
`define MC_zfactor_OUTER 4


// Constants for TestBench
`define ADD_SIZE_Cu `MEM_SIZE
`define ADD_SIZE_SL `MEM_SIZE
`define ADD_SIZE_AS 4+`MEM_SIZE
`define ADD_SIZE_VS 4+`MEM_SIZE
`define ADD_SIZE_SP 2+`MEM_SIZE
`define ADD_SIZE_TR 4+`MEM_SIZE
`define ADD_SIZE_TP 3+`MEM_SIZE
`define ADD_SIZE_VP 2+`MEM_SIZE
`define ADD_SIZE_AP 2+`MEM_SIZE
`define ADD_SIZE_CM 2+`MEM_SIZE
`define ADD_SIZE_FM 3+`MEM_SIZE
`define ADD_SIZE_TF `MEM_SIZE

