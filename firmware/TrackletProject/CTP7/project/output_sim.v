`timescale 1ns / 1ps

module output_sim(
		  input clk,
		  input reset,
		  input BC0
		  );
   parameter USER="/n/home00/lefeld.17/CMS/L1TrackFirmware/firmware/";
   
   // outputs (stub pairs, tracklets, final tracks)
   integer 		fdo;     //seeding in D3+D3
   integer 		fdo_L3L4;
   integer 		fdo_L5L6;
   integer 		fdoD3D4; //seeding in D3+D4
   integer 		fdoD4D4; //seeding in D4+D4
   integer 		fdoD3D4_L3L4;
   integer 		fdoD4D4_L3L4;
   integer 		fdoD3D4_L5L6;
   integer 		fdoD4D4_L5L6;
   integer 		fdoD5; // seeding in D5+D5
   integer      fdoD5_F3F4; //F3F4 seeding
   // ---------------------------------------------------------
   //projections for F1+F2 seeds
   //D5D6 project: for F1F2 and F3F4 tracklets formed only in D5+D5
   integer 		fdoProjOrigD5; 
   integer 		fdoProjPlusD5;
   integer 		fdoProjMinusD5;
   integer 		fdoProjD5D5OrigD6;
   
   integer 		fdoProjOrigD5_F3F4; 
   integer      fdoProjPlusD5_F3F4;
   integer      fdoProjMinusD5_F3F4;
   integer      fdoProjD5D5OrigD6_F3F4;
   
   // projections for D4D6 project
   integer      fdoProjD4D4OrigD5;
   integer      fdoProjD4D4OrigD6;
   integer      fdoProjD4D4OrigD6_L3L4;
   integer      fdoProjD4D4PlusD5D6;
   integer      fdoProjD4D4PlusD5D6_L3L4;
   integer      fdoProjD4D4MinusD5D6;
   integer      fdoProjD4D4MinusD5D6_L3L4; 
   integer      fdoProjD5D5OrigD4;
   integer      fdoProjD5D5PlusD4;
   integer      fdoProjD5D5MinusD4;   

   //projections for L1+L2 seeds 
   // D3D4 project: for L1L2 tracklets formed in D3+D4 or D4+D4 regions, only projections to D4 region are valid tracks
   integer 		fdoProjOrig;
   integer 		fdoProjPlus;
   integer 		fdoProjMinus;
   integer 		fdoProjOrigD4;     //projections for D3+D3 tracklet to D4 region
   integer 		fdoProjD3D4OrigD4; //projections for D3+D4 seeding
   integer 		fdoProjD4D4OrigD4; //projections for D4+D4 seeding
   integer 		fdoProjD3D4Plus;
   integer 		fdoProjD3D4Minus;
   integer 		fdoProjD4D4Plus;
   integer 		fdoProjD4D4Minus;
   // projections for L3+L4 seeds
   // D3D4 project: for L3L4 tracklets formed in D3+D4 or D4+D4 regions, projections both to D3 and D4 regions must be considered
   integer 		fdoProjOrig_L3L4;
   integer 		fdoProjPlus_L3L4;
   integer 		fdoProjMinus_L3L4;
   integer 		fdoProjOrigD4_L3L4;
   integer 		fdoProjD3D4Orig_L3L4;    
   integer 		fdoProjD4D4Orig_L3L4; 
   integer 		fdoProjD3D4OrigD4_L3L4; 
   integer 		fdoProjD4D4OrigD4_L3L4;
   integer 		fdoProjD3D4Plus_L3L4; 
   integer 		fdoProjD3D4Minus_L3L4;
   integer 		fdoProjD4D4Plus_L3L4;
   integer 		fdoProjD4D4Minus_L3L4;
   // projections for L5+L6 seeds
   // D3D4 project: for L5L6 tracklets formed in D3+D4 region, only projections both to D3 valid, but for D4+D4, projections can be to be D3 and D4 regions
   integer 		fdoProjOrig_L5L6;
   integer 		fdoProjPlus_L5L6;
   integer 		fdoProjMinus_L5L6;
   integer 		fdoProjD3D4Orig_L5L6;  
   integer 		fdoProjD4D4Orig_L5L6;
   integer 		fdoProjD4D4OrigD4_L5L6;
   integer 		fdoProjD3D4Plus_L5L6; 
   integer 		fdoProjD3D4Minus_L5L6;
   integer 		fdoProjD4D4Plus_L5L6;
   integer 		fdoProjD4D4Minus_L5L6;
   // all projections memories, we don't look at these for the moment... 
   integer 		fdoAllProj;
   // ---------------------------------------------------------
   // matches for F1+F2 seeds
   integer 		fdoMatchOrigD5;
   integer 		fdoMatchToMinusD5;
   integer 		fdoMatchToPlusD5;
   integer 		fdoMatchFromMinusD5D6;
   integer 		fdoMatchFromPlusD5D6;
   integer 		fdoMatchOrigD6;
   integer 		fdoMatchToMinusD6;
   integer 		fdoMatchToPlusD6; 
   // matches for F3+F4 seeds
   integer 		fdoMatchOrigD5_F3F4;
   integer      fdoMatchToMinusD5_F3F4;
   integer      fdoMatchToPlusD5_F3F4;
   integer      fdoMatchFromMinusD5D6_F3F4;
   integer      fdoMatchFromPlusD5D6_F3F4;
   integer      fdoMatchOrigD6_F3F4;
   integer      fdoMatchToMinusD6_F3F4;
   integer      fdoMatchToPlusD6_F3F4; 
   // matches for L1+L2 seeds
   integer 		fdoMatchOrig;
   integer 		fdoMatchOrigD4;
   integer 		fdoMatchToPlus;
   integer 		fdoMatchToPlusD4;
   integer 		fdoMatchToMinus;
   integer 		fdoMatchToMinusD4;
   integer 		fdoMatchFromPlus;
   integer 		fdoMatchFromMinus;
   // matches for L3+L4 seeds
   integer 		fdoMatchOrig_L3L4;
   integer 		fdoMatchOrigD4_L3L4;
   integer 		fdoMatchToPlus_L3L4;
   integer 		fdoMatchToPlusD4_L3L4;
   integer 		fdoMatchToMinus_L3L4;
   integer 		fdoMatchToMinusD4_L3L4;
   integer 		fdoMatchFromPlus_L3L4;
   integer 		fdoMatchFromMinus_L3L4;
   // matches for L5+L6 seeds
   integer 		fdoMatchOrig_L5L6;
   integer 		fdoMatchOrigD4_L5L6;
   integer 		fdoMatchToPlus_L5L6;
   integer 		fdoMatchToPlusD4_L5L6;
   integer 		fdoMatchToMinus_L5L6;
   integer 		fdoMatchToMinusD4_L5L6;
   integer 		fdoMatchFromPlus_L5L6;
   integer 		fdoMatchFromMinus_L5L6;
   // matches for D4D6 project
   integer      fdoMatchOrigD5_L1L2;
   integer      fdoMatchOrigD6_L1L2;
   integer      fdoMatchFromPlusD5D6_L1L2;
   integer      fdoMatchFromMinusD5D6_L1L2;
   integer      fdoMatchOrigD4_F1F2;
   integer      fdoMatchFromPlusD4_F1F2;
   integer      fdoMatchFromMinusD4_F1F2;
   

   // start processing
   initial begin
      
      // --------------------------------------------------------------------------------
      // OUTPUTS FOR D3 (and D3D4) PROJECT
      // --------------------------------------------------------------------------------
      
       fdo               = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_All_L1L2.dat"},"w"); 
       fdo_L3L4          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_All_L3L4.dat"},"w"); 
       fdo_L5L6          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_All_L5L6.dat"},"w"); 

       fdoProjOrig       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrig_L1L2.dat"},"w");
       fdoProjPlus       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjPlus_L1L2.dat"},"w");
       fdoProjMinus      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjMinus_L1L2.dat"},"w");
       fdoProjOrig_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrig_L3L4.dat"},"w");
       fdoProjPlus_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjPlus_L3L4.dat"},"w");
       fdoProjMinus_L3L4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjMinus_L3L4.dat"},"w");
       fdoProjOrig_L5L6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrig_L5L6.dat"},"w");
       fdoProjPlus_L5L6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjPlus_L5L6.dat"},"w");
       fdoProjMinus_L5L6 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjMinus_L5L6.dat"},"w");
       
       //fdoAllProj        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_Proj.dat"},"w");
       
       fdoMatchOrig      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_L1L2.dat"},"w");
       fdoMatchToMinus   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_L1L2.dat"},"w");
       fdoMatchToPlus    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_L1L2.dat"},"w");
       fdoMatchFromMinus = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinus_L1L2.dat"},"w");
       fdoMatchFromPlus  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlus_L1L2.dat"},"w");
       fdoMatchOrig_L3L4      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_L3L4.dat"},"w");
       fdoMatchToMinus_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_L3L4.dat"},"w");
       fdoMatchToPlus_L3L4    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_L3L4.dat"},"w");
       fdoMatchFromMinus_L3L4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinus_L3L4.dat"},"w");
       fdoMatchFromPlus_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlus_L3L4.dat"},"w");
       fdoMatchOrig_L5L6      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_L5L6.dat"},"w");
       fdoMatchToMinus_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_L5L6.dat"},"w");
       fdoMatchToPlus_L5L6    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_L5L6.dat"},"w");
       fdoMatchFromMinus_L5L6 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinus_L5L6.dat"},"w");
       fdoMatchFromPlus_L5L6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlus_L5L6.dat"},"w");
       
      
      // --------------------------------------------------------------------------------
      // ADDITIONAL OUTPUTS FOR THE D3D4 PROJECT
      // --------------------------------------------------------------------------------

      
       fdoD3D4        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD3D4_L1L2.dat"},"w"); 
       fdoD4D4        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD4D4_L1L2.dat"},"w"); 
       fdoD3D4_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD3D4_L3L4.dat"},"w"); 
       fdoD4D4_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD4D4_L3L4.dat"},"w"); 
       fdoD3D4_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD3D4_L5L6.dat"},"w"); 
       fdoD4D4_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD4D4_L5L6.dat"},"w"); 

       fdoProjOrigD4     = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrigD4_L1L2.dat"},"w");
       fdoProjD3D4OrigD4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4OrigD4_L1L2.dat"},"w");
       fdoProjD4D4OrigD4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD4_L1L2.dat"},"w");
       fdoProjD3D4Plus   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Plus_L1L2.dat"},"w");
       fdoProjD4D4Plus   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Plus_L1L2.dat"},"w");
       fdoProjD3D4Minus  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Minus_L1L2.dat"},"w");
       fdoProjD4D4Minus  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Minus_L1L2.dat"},"w");
       
       fdoProjOrigD4_L3L4     = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrigD4_L3L4.dat"},"w");
       fdoProjD3D4Orig_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Orig_L3L4.dat"},"w");
       fdoProjD4D4Orig_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Orig_L3L4.dat"},"w");
       fdoProjD3D4OrigD4_L3L4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4OrigD4_L3L4.dat"},"w");
       fdoProjD4D4OrigD4_L3L4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD4_L3L4.dat"},"w");
       fdoProjD3D4Plus_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Plus_L3L4.dat"},"w");
       fdoProjD4D4Plus_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Plus_L3L4.dat"},"w");
       fdoProjD3D4Minus_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Minus_L3L4.dat"},"w");
       fdoProjD4D4Minus_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Minus_L3L4.dat"},"w");

       fdoProjD3D4Orig_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Orig_L5L6.dat"},"w");
       fdoProjD4D4Orig_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Orig_L5L6.dat"},"w");
       fdoProjD4D4OrigD4_L5L6 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD4_L5L6.dat"},"w");
       fdoProjD3D4Plus_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Plus_L5L6.dat"},"w");
       fdoProjD4D4Plus_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Plus_L5L6.dat"},"w");
       fdoProjD3D4Minus_L5L6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD3D4Minus_L5L6.dat"},"w");
       fdoProjD4D4Minus_L5L6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Minus_L5L6.dat"},"w");
       
       fdoMatchOrigD4         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD4_L1L2.dat"},"w");
       fdoMatchToPlusD4       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlusD4_L1L2.dat"},"w");
       fdoMatchToMinusD4      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinusD4_L1L2.dat"},"w");
       fdoMatchOrigD4_L3L4    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD4_L3L4.dat"},"w");
       fdoMatchToPlusD4_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlusD4_L3L4.dat"},"w");
       fdoMatchToMinusD4_L3L4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinusD4_L3L4.dat"},"w");
       fdoMatchOrigD4_L5L6    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD4_L5L6.dat"},"w");
       fdoMatchToPlusD4_L5L6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlusD4_L5L6.dat"},"w");
       fdoMatchToMinusD4_L5L6 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinusD4_L5L6.dat"},"w");

      /*
      // --------------------------------------------------------------------------------
      // OUTPUTS FOR THE D5 PROJECT f1f2 and f3f4 seeding
      // --------------------------------------------------------------------------------
      fdoD5                 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_All_D5_F1F2.dat"},"w");
      fdoProjOrigD5         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrig_D5_F1F2.dat"},"w");
      fdoProjPlusD5         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjPlus_D5_F1F2.dat"},"w");
      fdoProjMinusD5        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjMinus_D5_F1F2.dat"},"w");
      fdoMatchOrigD5        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_D5_F1F2.dat"},"w");
      fdoMatchToMinusD5     = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_D5_F1F2.dat"},"w");
      fdoMatchToPlusD5      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_D5_F1F2.dat"},"w");
      fdoMatchFromMinusD5D6 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinus_D5_F1F2.dat"},"w");
      fdoMatchFromPlusD5D6  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlus_D5_F1F2.dat"},"w");
    
         
      fdoD5_F3F4                  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_All_D5_F3F4.dat"},"w");
      fdoProjOrigD5_F3F4          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjOrig_D5_F3F4.dat"},"w");
      fdoProjPlusD5_F3F4          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjPlus_D5_F3F4.dat"},"w");
      fdoProjMinusD5_F3F4         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjMinus_D5_F3F4.dat"},"w");
      fdoMatchOrigD5_F3F4         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_D5_F3F4.dat"},"w");
      fdoMatchToMinusD5_F3F4      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_D5_F3F4.dat"},"w");
      fdoMatchToPlusD5_F3F4       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_D5_F3F4.dat"},"w");
      fdoMatchFromMinusD5D6_F3F4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinus_D5_F3F4.dat"},"w");
      fdoMatchFromPlusD5D6_F3F4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlus_D5_F3F4.dat"},"w");
      
      
      
      // --------------------------------------------------------------------------------
      // ADDITIONAL OUTPUTS FOR THE D4D6 PROJECT
      // --------------------------------------------------------------------------------     
      // Some of these are copies from the D3D4 project, but copied so easier to use
      
      // stub pairs, tracklets, tracks, cleantracks
      fdoD4D4                  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD4D4_L1L2.dat"},"w"); 
      fdoD4D4_L3L4             = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD4D4_L3L4.dat"},"w"); 
      fdoD4D4_L5L6             = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_AllD4D4_L5L6.dat"},"w"); 
      
      // projections in D4 from D4D4 seeded tracklets
      fdoProjD4D4OrigD4        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD4_L1L2.dat"},"w");
      fdoProjD4D4Plus          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Plus_L1L2.dat"},"w");
      fdoProjD4D4Minus         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Minus_L1L2.dat"},"w");
      fdoProjD4D4OrigD4_L3L4   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD4_L3L4.dat"},"w");
      fdoProjD4D4Plus_L3L4     = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Plus_L3L4.dat"},"w");
      fdoProjD4D4Minus_L3L4    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Minus_L3L4.dat"},"w");
      fdoProjD4D4OrigD4_L5L6   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD4_L5L6.dat"},"w");
      fdoProjD4D4Plus_L5L6     = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Plus_L5L6.dat"},"w");
      fdoProjD4D4Minus_L5L6    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4Minus_L5L6.dat"},"w");
      // projections in D5 from D4D4 seeded tracklets
      fdoProjD4D4OrigD5         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD5_L1L2_F.dat"},"w"); 
      // projections in D6 from D4D4 seeded tracklets
      fdoProjD4D4OrigD6         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD6_L1L2_F.dat"},"w"); 
      fdoProjD4D4OrigD6_L3L4    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4OrigD6_L3L4_F.dat"},"w"); 
      // projections to disks (plus/minus) from D4D4 seeded tracklets
      fdoProjD4D4PlusD5D6       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4PlusD5D6_L1L2_F.dat"},"w");
      fdoProjD4D4MinusD5D6      = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4MinusD5D6_L1L2_F.dat"},"w");       
      fdoProjD4D4PlusD5D6_L3L4  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4PlusD5D6_L3L4_F.dat"},"w");
      fdoProjD4D4MinusD5D6_L3L4 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD4D4MinusD5D6_L3L4_F.dat"},"w");        
      // projections to barrel from D5D5 seeded tracklets
      fdoProjD5D5OrigD4         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD5D5OrigD4_F1F2_L.dat"},"w"); 
      fdoProjD5D5PlusD4         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD5D5PlusD4_F1F2_L.dat"},"w");
      fdoProjD5D5MinusD4        = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD5D5MinusD4_F1F2_L.dat"},"w");      

      // matches in D4 from D4D4 seeded tracklets
      fdoMatchOrigD4            = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD4_L1L2.dat"},"w");
      fdoMatchToPlusD4          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlusD4_L1L2.dat"},"w");
      fdoMatchToMinusD4         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinusD4_L1L2.dat"},"w");
      // matches in D5 or D6 from D4D4
      fdoMatchOrigD5_L1L2       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD5_L1L2.dat"},"w");
      fdoMatchOrigD6_L1L2       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD6_L1L2.dat"},"w");
      fdoMatchFromPlusD5D6_L1L2 = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlusD5D6_L1L2.dat"},"w");
      fdoMatchFromMinusD5D6_L1L2= $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinusD5D6_L1L2.dat"},"w");
      // matches in D4 from D5D5 tracklet
      fdoMatchOrigD4_F1F2       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrigD4_F1F2.dat"},"w");
      fdoMatchFromPlusD4_F1F2   = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromPlusD4_F1F2.dat"},"w");
      fdoMatchFromMinusD4_F1F2  = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesFromMinusD4_F1F2.dat"},"w");
      

      
      // --------------------------------------------------------------------------------
      // ADDITIONAL OUTPUTS FOR THE D5D6 PROJECT (Seeding ONLY done in D5+D5)
      // --------------------------------------------------------------------------------    

      fdoProjD5D5OrigD6         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD5D5Orig_D6_F1F2.dat"},"w");
      fdoMatchOrigD6            = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_D6_F1F2.dat"},"w");
      fdoMatchToMinusD6         = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_D6_F1F2.dat"},"w");
      fdoMatchToPlusD6          = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_D6_F1F2.dat"},"w");
        
      fdoProjD5D5OrigD6_F3F4    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_ProjD5D5Orig_D6_F3F4.dat"},"w");
      fdoMatchOrigD6_F3F4       = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesOrig_D6_F3F4.dat"},"w");
      fdoMatchToMinusD6_F3F4    = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToMinus_D6_F3F4.dat"},"w");
      fdoMatchToPlusD6_F3F4     = $fopen({USER,"/TrackletProject/AdditionalFiles/Output_MatchesToPlus_D6_F3F4.dat"},"w");
      */

   end
  
   
   // --------------------------------------------------------------------------------
   // D5 PROJECT  F1F2 and F3F4 seeding
   // --------------------------------------------------------------------------------
   /*
   always @(posedge clk) begin
      // stubpairs, tracklet, track
      // D5+D5 seeding projecting into D5
      $fwrite(fdoD5, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
	      uut_central.tracklet_processing.TC_F1D5F2D5.pre_valid_trackpar,
	      uut_central.tracklet_processing.TC_F1D5F2D5.BX_pipe,
	      uut_central.tracklet_processing.TC_F1D5F2D5.innerallstubin,
	      uut_central.tracklet_processing.TC_F1D5F2D5.outerallstubin,  
	      uut_central.tracklet_processing.TPAR_F1D5F2D5.enable,
	      uut_central.tracklet_processing.TPAR_F1D5F2D5.BX_pipe,
	      uut_central.tracklet_processing.TPAR_F1D5F2D5.data_in,
	      uut_central.tracklet_processing.FT_F1F2.valid_fit,
	      uut_central.tracklet_processing.FT_F1F2.BX_pipe-5'b11111,
	      uut_central.tracklet_processing.FT_F1F2.trackout,
          uut_central.tracklet_processing.CT_F1F2.enable,
          uut_central.tracklet_processing.CT_F1F2.BX_pipe-3'b111,
          uut_central.tracklet_processing.CT_F1F2.data_in
	      );
      
     $fwrite(fdoD5_F3F4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
          uut_central.tracklet_processing.TC_F3D5F4D5.pre_valid_trackpar,
          uut_central.tracklet_processing.TC_F3D5F4D5.BX_pipe,
          uut_central.tracklet_processing.TC_F3D5F4D5.innerallstubin,
          uut_central.tracklet_processing.TC_F3D5F4D5.outerallstubin,  
          uut_central.tracklet_processing.TPAR_F3D5F4D5.enable,
          uut_central.tracklet_processing.TPAR_F3D5F4D5.BX_pipe,
          uut_central.tracklet_processing.TPAR_F3D5F4D5.data_in,
          uut_central.tracklet_processing.FT_F3F4.valid_fit,
          uut_central.tracklet_processing.FT_F3F4.BX_pipe-5'b11111,
          uut_central.tracklet_processing.FT_F3F4.trackout,        
          uut_central.tracklet_processing.CT_F3F4.enable,
          uut_central.tracklet_processing.CT_F3F4.BX_pipe-3'b111,
          uut_central.tracklet_processing.CT_F3F4.data_in 
          );
              
         
      
      // projections directly out of the Tracklet Calculator
      // projections to original sector
      $fwrite(fdoProjOrigD5, "%x %x %x %x %x %x %x %x %x x x x\n",
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F3D5.wr_en,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F3D5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F3D5.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F4D5.wr_en,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F4D5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F4D5.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F5D5.wr_en,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F5D5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_F1D5F2D5_F5D5.data_in_dly
	      );
      $fwrite(fdoProjOrigD5_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F1D5.wr_en,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F1D5.BX_pipe,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F1D5.data_in_dly,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F2D5.wr_en,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F2D5.BX_pipe,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F2D5.data_in_dly,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F5D5.wr_en,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F5D5.BX_pipe,
          uut_central.tracklet_processing.TPROJ_F3D5F4D5_F5D5.data_in_dly
          );	      
	      
	    
	      
	      
	      
      // projections to minus sector
      $fwrite(fdoProjMinusD5, "%x %x %x %x %x %x %x %x %x x x x\n",
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F3.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F3.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F3.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F4.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F4.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F4.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F5.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_F5.data_in_dly
	      );

      $fwrite(fdoProjMinusD5_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F1.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F1.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F1.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F2.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F2.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F2.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F5.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToMinus_F3D5F4D5_F5.data_in_dly
	      );	      
	      
	      
      // projections to plus sector
      $fwrite(fdoProjPlusD5, "%x %x %x %x %x %x %x %x %x x x x\n",
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F3.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F3.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F3.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F4.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F4.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F4.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F5.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_F5.data_in_dly
	      );  
	      
      $fwrite(fdoProjPlusD5_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F1.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F1.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F1.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F2.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F2.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F2.data_in_dly,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F5.wr_en,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F5.BX_pipe,
	      uut_central.tracklet_processing.TPROJ_ToPlus_F3D5F4D5_F5.data_in_dly
	      );  	      
      

      
      
      // matches in original sector
      $fwrite(fdoMatchOrigD5, "%x %x %x %x %x %x %x %x %x x x x\n",
	      uut_central.tracklet_processing.FM_F1F2_F3D5.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F3D5.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F3D5.data_in_dly2,
	      uut_central.tracklet_processing.FM_F1F2_F4D5.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F4D5.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F4D5.data_in_dly2,            
	      uut_central.tracklet_processing.FM_F1F2_F5D5.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F5D5.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F5D5.data_in_dly2            
	      );
      $fwrite(fdoMatchOrigD5_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",
          uut_central.tracklet_processing.FM_F3F4_F1D5.wr_en,
          uut_central.tracklet_processing.FM_F3F4_F1D5.BX_pipe,
          uut_central.tracklet_processing.FM_F3F4_F1D5.data_in_dly2,
          uut_central.tracklet_processing.FM_F3F4_F2D5.wr_en,
          uut_central.tracklet_processing.FM_F3F4_F2D5.BX_pipe,
          uut_central.tracklet_processing.FM_F3F4_F2D5.data_in_dly2,            
          uut_central.tracklet_processing.FM_F3F4_F5D5.wr_en,
          uut_central.tracklet_processing.FM_F3F4_F5D5.BX_pipe,
          uut_central.tracklet_processing.FM_F3F4_F5D5.data_in_dly2            
          );	      
	      
	   
	      
      // matches to minus neighbor
      $fwrite(fdoMatchToMinusD5, "%x %x %x %x %x %x %x %x %x x x x\n",    
	      uut_plus.tracklet_processing.FM_F1F2_F3D5_ToMinus.wr_en,
	      uut_plus.tracklet_processing.FM_F1F2_F3D5_ToMinus.BX_pipe,
	      uut_plus.tracklet_processing.FM_F1F2_F3D5_ToMinus.data_in_dly2,
	      uut_plus.tracklet_processing.FM_F1F2_F4D5_ToMinus.wr_en,
	      uut_plus.tracklet_processing.FM_F1F2_F4D5_ToMinus.BX_pipe,
	      uut_plus.tracklet_processing.FM_F1F2_F4D5_ToMinus.data_in_dly2,             
	      uut_plus.tracklet_processing.FM_F1F2_F5D5_ToMinus.wr_en,
	      uut_plus.tracklet_processing.FM_F1F2_F5D5_ToMinus.BX_pipe,
	      uut_plus.tracklet_processing.FM_F1F2_F5D5_ToMinus.data_in_dly2            
	      );
	   
//      $fwrite(fdoMatchToMinusD5_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",    
//          uut_plus.tracklet_processing.FM_F3F4_F1D5_ToMinus.wr_en,
//          uut_plus.tracklet_processing.FM_F3F4_F1D5_ToMinus.BX_pipe,
//          uut_plus.tracklet_processing.FM_F3F4_F1D5_ToMinus.data_in_dly2,
//          uut_plus.tracklet_processing.FM_F3F4_F2D5_ToMinus.wr_en,
//          uut_plus.tracklet_processing.FM_F3F4_F2D5_ToMinus.BX_pipe,
//          uut_plus.tracklet_processing.FM_F3F4_F2D5_ToMinus.data_in_dly2,             
//          uut_plus.tracklet_processing.FM_F3F4_F5D5_ToMinus.wr_en,
//          uut_plus.tracklet_processing.FM_F3F4_F5D5_ToMinus.BX_pipe,
//          uut_plus.tracklet_processing.FM_F3F4_F5D5_ToMinus.data_in_dly2            
//          );	      
	     
	      
	      
	      
      // matches to plus neighbor
      $fwrite(fdoMatchToPlusD5, "%x %x %x %x %x %x %x %x %x x x x\n",              
	      uut_minus.tracklet_processing.FM_F1F2_F3D5_ToPlus.wr_en,
	      uut_minus.tracklet_processing.FM_F1F2_F3D5_ToPlus.BX_pipe,
	      uut_minus.tracklet_processing.FM_F1F2_F3D5_ToPlus.data_in_dly2,
	      uut_minus.tracklet_processing.FM_F1F2_F4D5_ToPlus.wr_en,
	      uut_minus.tracklet_processing.FM_F1F2_F4D5_ToPlus.BX_pipe,
	      uut_minus.tracklet_processing.FM_F1F2_F4D5_ToPlus.data_in_dly2, 
	      uut_minus.tracklet_processing.FM_F1F2_F5D5_ToPlus.wr_en,
	      uut_minus.tracklet_processing.FM_F1F2_F5D5_ToPlus.BX_pipe,
	      uut_minus.tracklet_processing.FM_F1F2_F5D5_ToPlus.data_in_dly2
	      );
	 
//      $fwrite(fdoMatchToPlusD5_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",              
//          uut_minus.tracklet_processing.FM_F3F4_F1D5_ToPlus.wr_en,
//          uut_minus.tracklet_processing.FM_F3F4_F1D5_ToPlus.BX_pipe,
//          uut_minus.tracklet_processing.FM_F3F4_F1D5_ToPlus.data_in_dly2,
//          uut_minus.tracklet_processing.FM_F3F4_F2D5_ToPlus.wr_en,
//          uut_minus.tracklet_processing.FM_F3F4_F2D5_ToPlus.BX_pipe,
//          uut_minus.tracklet_processing.FM_F3F4_F2D5_ToPlus.data_in_dly2, 
//          uut_minus.tracklet_processing.FM_F3F4_F5D5_ToPlus.wr_en,
//          uut_minus.tracklet_processing.FM_F3F4_F5D5_ToPlus.BX_pipe,
//          uut_minus.tracklet_processing.FM_F3F4_F5D5_ToPlus.data_in_dly2
//          );
           	      
	      
	      
      // matches from minus neighbor
      $fwrite(fdoMatchFromMinusD5D6, "%x %x %x %x %x %x %x %x %x x x x\n",    
	      uut_central.tracklet_processing.FM_F1F2_F3_FromMinus.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F3_FromMinus.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F3_FromMinus.data_in_dly2,
	      uut_central.tracklet_processing.FM_F1F2_F4_FromMinus.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F4_FromMinus.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F4_FromMinus.data_in_dly2,             
	      uut_central.tracklet_processing.FM_F1F2_F5_FromMinus.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F5_FromMinus.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F5_FromMinus.data_in_dly2             
	      );
	      
	 
//      $fwrite(fdoMatchFromMinusD5D6_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",    
//          uut_central.tracklet_processing.FM_F3F4_F1_FromMinus.wr_en,
//          uut_central.tracklet_processing.FM_F3F4_F1_FromMinus.BX_pipe,
//          uut_central.tracklet_processing.FM_F3F4_F1_FromMinus.data_in_dly2,
//          uut_central.tracklet_processing.FM_F3F4_F2_FromMinus.wr_en,
//          uut_central.tracklet_processing.FM_F3F4_F2_FromMinus.BX_pipe,
//          uut_central.tracklet_processing.FM_F3F4_F2_FromMinus.data_in_dly2,             
//          uut_central.tracklet_processing.FM_F3F4_F5_FromMinus.wr_en,
//          uut_central.tracklet_processing.FM_F3F4_F5_FromMinus.BX_pipe,
//          uut_central.tracklet_processing.FM_F3F4_F5_FromMinus.data_in_dly2             
//          );	      
	   
	      
      // matches from plus neighbor
      $fwrite(fdoMatchFromPlusD5D6, "%x %x %x %x %x %x %x %x %x x x x\n",              
	      uut_central.tracklet_processing.FM_F1F2_F3_FromPlus.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F3_FromPlus.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F3_FromPlus.data_in_dly2,
	      uut_central.tracklet_processing.FM_F1F2_F4_FromPlus.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F4_FromPlus.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F4_FromPlus.data_in_dly2, 
	      uut_central.tracklet_processing.FM_F1F2_F5_FromPlus.wr_en,
	      uut_central.tracklet_processing.FM_F1F2_F5_FromPlus.BX_pipe,
	      uut_central.tracklet_processing.FM_F1F2_F5_FromPlus.data_in_dly2
	      ); 
	      
	  
//      $fwrite(fdoMatchFromPlusD5D6_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",              
//          uut_central.tracklet_processing.FM_F3F4_F1_FromPlus.wr_en,
//          uut_central.tracklet_processing.FM_F3F4_F1_FromPlus.BX_pipe,
//          uut_central.tracklet_processing.FM_F3F4_F1_FromPlus.data_in_dly2,
//          uut_central.tracklet_processing.FM_F3F4_F2_FromPlus.wr_en,
//          uut_central.tracklet_processing.FM_F3F4_F2_FromPlus.BX_pipe,
//          uut_central.tracklet_processing.FM_F3F4_F2_FromPlus.data_in_dly2, 
//          uut_central.tracklet_processing.FM_F3F4_F5_FromPlus.wr_en,
//          uut_central.tracklet_processing.FM_F3F4_F5_FromPlus.BX_pipe,
//          uut_central.tracklet_processing.FM_F3F4_F5_FromPlus.data_in_dly2
//          );	      
	        
   end
   
   
   */
   
   
   /*
   // --------------------------------------------------------------------------------
   // Additional files for D5D6 PROJECT 
   // --------------------------------------------------------------------------------       
   
   always @ (posedge clk) begin
      // FOR D5D6 PROJECT 
      // tracklet seeded in D5+D6, projecting to D6
      $fwrite(fdoProjD5D5OrigD6, "%x %x %x %x %x %x %x %x %x x x x\n",
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F3D6.wr_en,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F3D6.BX_pipe,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F3D6.data_in_dly,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F4D6.wr_en,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F4D6.BX_pipe,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F4D6.data_in_dly,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F5D6.wr_en,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F5D6.BX_pipe,
              uut_central.tracklet_processing.TPROJ_F1D5F2D5_F5D6.data_in_dly
              );
      $fwrite(fdoProjD5D5OrigD6_F3F4, "x x x x x x %x %x %x x x x\n",
              uut_central.tracklet_processing.TPROJ_F3D5F4D5_F5D6.wr_en,
              uut_central.tracklet_processing.TPROJ_F3D5F4D5_F5D6.BX_pipe,
              uut_central.tracklet_processing.TPROJ_F3D5F4D5_F5D6.data_in_dly
              );             
    
              
      $fwrite(fdoMatchOrigD6, "%x %x %x %x %x %x %x %x %x x x x\n",
              // matches in original sector
              uut_central.tracklet_processing.FM_F1F2_F3D6.wr_en,
              uut_central.tracklet_processing.FM_F1F2_F3D6.BX_pipe,
              uut_central.tracklet_processing.FM_F1F2_F3D6.data_in_dly2,
              uut_central.tracklet_processing.FM_F1F2_F4D6.wr_en,
              uut_central.tracklet_processing.FM_F1F2_F4D6.BX_pipe,
              uut_central.tracklet_processing.FM_F1F2_F4D6.data_in_dly2,            
              uut_central.tracklet_processing.FM_F1F2_F5D6.wr_en,
              uut_central.tracklet_processing.FM_F1F2_F5D6.BX_pipe,
              uut_central.tracklet_processing.FM_F1F2_F5D6.data_in_dly2
              );
              
              
      $fwrite(fdoMatchOrigD6_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",
                      // matches in original sector
              uut_central.tracklet_processing.FM_F3F4_F1D6.wr_en,
              uut_central.tracklet_processing.FM_F3F4_F1D6.BX_pipe,
              uut_central.tracklet_processing.FM_F3F4_F1D6.data_in_dly2,
              uut_central.tracklet_processing.FM_F3F4_F2D6.wr_en,
              uut_central.tracklet_processing.FM_F3F4_F2D6.BX_pipe,
              uut_central.tracklet_processing.FM_F3F4_F2D6.data_in_dly2,            
              uut_central.tracklet_processing.FM_F3F4_F5D6.wr_en,
              uut_central.tracklet_processing.FM_F3F4_F5D6.BX_pipe,
              uut_central.tracklet_processing.FM_F3F4_F5D6.data_in_dly2
              );    
                        
      $fwrite(fdoMatchToMinusD6, "%x %x %x %x %x %x %x %x %x x x x\n",    
              // matches in minus neighbor
              uut_plus.tracklet_processing.FM_F1F2_F3D6_ToMinus.wr_en,
              uut_plus.tracklet_processing.FM_F1F2_F3D6_ToMinus.BX_pipe,
              uut_plus.tracklet_processing.FM_F1F2_F3D6_ToMinus.data_in_dly2,
              uut_plus.tracklet_processing.FM_F1F2_F4D6_ToMinus.wr_en,
              uut_plus.tracklet_processing.FM_F1F2_F4D6_ToMinus.BX_pipe,
              uut_plus.tracklet_processing.FM_F1F2_F4D6_ToMinus.data_in_dly2,             
              uut_plus.tracklet_processing.FM_F1F2_F5D6_ToMinus.wr_en,
              uut_plus.tracklet_processing.FM_F1F2_F5D6_ToMinus.BX_pipe,
              uut_plus.tracklet_processing.FM_F1F2_F5D6_ToMinus.data_in_dly2
              );   
         
//      $fwrite(fdoMatchToMinusD6_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",    
//                      // matches in minus neighbor
//              uut_plus.tracklet_processing.FM_F3F4_F1D6_ToMinus.wr_en,
//              uut_plus.tracklet_processing.FM_F3F4_F1D6_ToMinus.BX_pipe,
//              uut_plus.tracklet_processing.FM_F3F4_F1D6_ToMinus.data_in_dly2,
//              uut_plus.tracklet_processing.FM_F3F4_F2D6_ToMinus.wr_en,
//              uut_plus.tracklet_processing.FM_F3F4_F2D6_ToMinus.BX_pipe,
//              uut_plus.tracklet_processing.FM_F3F4_F2D6_ToMinus.data_in_dly2,             
//              uut_plus.tracklet_processing.FM_F3F4_F5D6_ToMinus.wr_en,
//              uut_plus.tracklet_processing.FM_F3F4_F5D6_ToMinus.BX_pipe,
//              uut_plus.tracklet_processing.FM_F3F4_F5D6_ToMinus.data_in_dly2
//              );              
               
      $fwrite(fdoMatchToPlusD6, "%x %x %x %x %x %x %x %x %x x x x\n",    
              // matches in plus neighbor
              uut_minus.tracklet_processing.FM_F1F2_F3D6_ToPlus.wr_en,
              uut_minus.tracklet_processing.FM_F1F2_F3D6_ToPlus.BX_pipe,
              uut_minus.tracklet_processing.FM_F1F2_F3D6_ToPlus.data_in_dly2,
              uut_minus.tracklet_processing.FM_F1F2_F4D6_ToPlus.wr_en,
              uut_minus.tracklet_processing.FM_F1F2_F4D6_ToPlus.BX_pipe,
              uut_minus.tracklet_processing.FM_F1F2_F4D6_ToPlus.data_in_dly2,             
              uut_minus.tracklet_processing.FM_F1F2_F5D6_ToPlus.wr_en,
              uut_minus.tracklet_processing.FM_F1F2_F5D6_ToPlus.BX_pipe,
              uut_minus.tracklet_processing.FM_F1F2_F5D6_ToPlus.data_in_dly2
              );
              
           
//      $fwrite(fdoMatchToPlusD6_F3F4, "%x %x %x %x %x %x %x %x %x x x x\n",    
//              // matches in plus neighbor
//              uut_minus.tracklet_processing.FM_F3F4_F1D6_ToPlus.wr_en,
//              uut_minus.tracklet_processing.FM_F3F4_F1D6_ToPlus.BX_pipe,
//              uut_minus.tracklet_processing.FM_F3F4_F1D6_ToPlus.data_in_dly2,
//              uut_minus.tracklet_processing.FM_F3F4_F2D6_ToPlus.wr_en,
//              uut_minus.tracklet_processing.FM_F3F4_F2D6_ToPlus.BX_pipe,
//              uut_minus.tracklet_processing.FM_F3F4_F2D6_ToPlus.data_in_dly2,             
//              uut_minus.tracklet_processing.FM_F3F4_F5D6_ToPlus.wr_en,
//              uut_minus.tracklet_processing.FM_F3F4_F5D6_ToPlus.BX_pipe,
//              uut_minus.tracklet_processing.FM_F3F4_F5D6_ToPlus.data_in_dly2
//              );
   


   end
   */
   

   // --------------------------------------------------------------------------------
   // ADDITIONAL OUTPUTS FOR D4D6 PROJECT 
   // --------------------------------------------------------------------------------
   /*
   always @(posedge clk) begin
   
        $fwrite(fdoD4D4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TC_L1D4L2D4.pre_valid_trackpar,
        uut_central.tracklet_processing.TC_L1D4L2D4.BX_pipe-3'b111,
        uut_central.tracklet_processing.TC_L1D4L2D4.innerallstubin,
        uut_central.tracklet_processing.TC_L1D4L2D4.outerallstubin,  
        uut_central.tracklet_processing.TPAR_L1D4L2D4.enable,
        uut_central.tracklet_processing.TPAR_L1D4L2D4.BX_pipe,
        uut_central.tracklet_processing.TPAR_L1D4L2D4.data_in,
        uut_central.tracklet_processing.FT_L1L2.valid_fit,
        uut_central.tracklet_processing.FT_L1L2.BX_pipe-3'b111,
        uut_central.tracklet_processing.FT_L1L2.trackout,
        uut_central.tracklet_processing.CT_L1L2.enable,
        uut_central.tracklet_processing.CT_L1L2.BX_pipe-3'b111,
        uut_central.tracklet_processing.CT_L1L2.data_in
        );
        $fwrite(fdoD4D4_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TC_L3D4L4D4.pre_valid_trackpar,
        uut_central.tracklet_processing.TC_L3D4L4D4.BX_pipe-3'b111,
        uut_central.tracklet_processing.TC_L3D4L4D4.innerallstubin,
        uut_central.tracklet_processing.TC_L3D4L4D4.outerallstubin,  
        uut_central.tracklet_processing.TPAR_L3D4L4D4.enable,
        uut_central.tracklet_processing.TPAR_L3D4L4D4.BX_pipe,
        uut_central.tracklet_processing.TPAR_L3D4L4D4.data_in,
        uut_central.tracklet_processing.FT_L3L4.valid_fit,
        uut_central.tracklet_processing.FT_L3L4.BX_pipe-3'b111,
        uut_central.tracklet_processing.FT_L3L4.trackout,
        uut_central.tracklet_processing.CT_L3L4.enable,
        uut_central.tracklet_processing.CT_L3L4.BX_pipe-3'b111,
        uut_central.tracklet_processing.CT_L3L4.data_in
        );
//        $fwrite(fdoD4D4_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
//        uut_central.tracklet_processing.TC_L5D4L6D4.pre_valid_trackpar,
//        uut_central.tracklet_processing.TC_L5D4L6D4.BX_pipe-3'b111,
//        uut_central.tracklet_processing.TC_L5D4L6D4.innerallstubin,
//        uut_central.tracklet_processing.TC_L5D4L6D4.outerallstubin,  
//        uut_central.tracklet_processing.TPAR_L5D4L6D4.enable,
//        uut_central.tracklet_processing.TPAR_L5D4L6D4.BX_pipe,
//        uut_central.tracklet_processing.TPAR_L5D4L6D4.data_in,
//        uut_central.tracklet_processing.FT_L5L6.valid_fit,
//        uut_central.tracklet_processing.FT_L5L6.BX_pipe-3'b111,
//        uut_central.tracklet_processing.FT_L5L6.trackout,
//        uut_central.tracklet_processing.CT_L5L6.enable,
//        uut_central.tracklet_processing.CT_L5L6.BX_pipe-3'b111,
//        uut_central.tracklet_processing.CT_L5L6.data_in
//        ); 
        
        // tracklets seeded in D4+D4, projecting to D4
        $fwrite(fdoProjD4D4OrigD4, "%x %x %x x x x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_L3D4.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_L3D4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_L3D4.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L4D4.wr_en,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L4D4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L4D4.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L5D4.wr_en,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L5D4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L5D4.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L6D4.wr_en,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L6D4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L6D4.data_in_dly
        );
        $fwrite(fdoProjD4D4OrigD4_L3L4, "x x x %x %x %x %x %x %x %x %x %x\n",
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D4.wr_en,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D4.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D4.wr_en,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D4.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D4.wr_en,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D4.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D4.wr_en,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D4.data_in_dly
        );
//        $fwrite(fdoProjD4D4OrigD4_L5L6, "x x x x x x %x %x %x %x %x %x\n",
//        //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D4.wr_en,
//        //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D4.BX_pipe,
//        //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D4.data_in_dly,
//        //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D4.wr_en,
//        //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D4.BX_pipe,
//        //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D4.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D4.wr_en,
//        uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D4.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D4.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D4.wr_en,
//        uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D4.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D4.data_in_dly
//        ); 
        
        // tracklets seeded in D4+D4, projecting to minus/plus sectors
        $fwrite(fdoProjD4D4Minus, "%x %x %x x x x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L3.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L3.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L3.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L4.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L4.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L5.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L5.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L5.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L6.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L6.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L6.data_in_dly        
        );
        $fwrite(fdoProjD4D4Minus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L2.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L5.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L5.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L5.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L6.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L6.data_in_dly        
        );
//        $fwrite(fdoProjD4D4Minus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L1.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L1.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L1.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L2.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L2.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L2.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L3.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L3.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L3.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L4.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L4.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L4.data_in_dly        
//        );
   
        $fwrite(fdoProjD4D4Plus, "%x %x %x x x x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L3.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L3.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L3.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L4.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L4.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L5.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L5.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L5.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L6.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L6.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L6.data_in_dly            
        );
        $fwrite(fdoProjD4D4Plus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L2.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L5.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L5.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L5.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L6.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L6.data_in_dly            
        );
//        $fwrite(fdoProjD4D4Plus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L1.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L1.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L1.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L2.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L2.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L2.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L3.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L3.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L3.data_in_dly,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L4.wr_en,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L4.BX_pipe,
//        uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L4.data_in_dly            
//        );        
        // tracklets seeded in D4+D4, projecting to D5
        $fwrite(fdoProjD4D4OrigD5, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F1D5.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F1D5.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F1D5.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F2D5.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F2D5.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F2D5.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F3D5.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F3D5.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F3D5.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F4D5.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F4D5.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F4D5.data_in_dly
        );
        // tracklets seeded in D4+D4, projecting to D6
        $fwrite(fdoProjD4D4OrigD6, "x x x %x %x %x %x %x %x %x %x %x\n",
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_F1D6.wr_en,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_F1D6.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L1D4L2D4_F1D6.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F2D6.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F2D6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F2D6.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F3D6.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F3D6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F3D6.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F4D6.wr_en,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F4D6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L1D4L2D4_F4D6.data_in_dly
        );        
        $fwrite(fdoProjD4D4OrigD6_L3L4, "%x %x %x %x %x %x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_F1D6.wr_en,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_F1D6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_F1D6.data_in_dly,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_F2D6.wr_en,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_F2D6.BX_pipe,
        uut_central.tracklet_processing.TPROJ_L3D4L4D4_F2D6.data_in_dly
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_F3D6.wr_en,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_F3D6.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_F3D6.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_F4D6.wr_en,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_F4D6.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_L3D4L4D4_F4D6.data_in_dly
        );   
                 
        // tracklets seeded in D4+D4, projecting to minus/plus sectors in disks
        $fwrite(fdoProjD4D4MinusD5D6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F2.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F3.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F3.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F3.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F4.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_F4.data_in_dly        
        );
        $fwrite(fdoProjD4D4MinusD5D6_L3L4, "%x %x %x %x %x %x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F2.data_in_dly
        //uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F3.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F3.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F3.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F4.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_F4.data_in_dly        
        );
        $fwrite(fdoProjD4D4PlusD5D6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F2.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F3.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F3.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F3.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F4.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_F4.data_in_dly        
        );
        $fwrite(fdoProjD4D4PlusD5D6_L3L4, "%x %x %x %x %x %x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F2.data_in_dly
        //uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F3.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F3.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F3.data_in_dly,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F4.wr_en,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F4.BX_pipe,
        //uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_F4.data_in_dly        
        );
        
        //projections seeded in disks the project to barrel (plus/minus sector)
        $fwrite(fdoProjD5D5OrigD4, "%x %x %x %x %x %x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_F1D5F2D5_L1D4.wr_en,
        uut_central.tracklet_processing.TPROJ_F1D5F2D5_L1D4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_F1D5F2D5_L1D4.data_in_dly,
        uut_central.tracklet_processing.TPROJ_F1D5F2D5_L2D4.wr_en,
        uut_central.tracklet_processing.TPROJ_F1D5F2D5_L2D4.BX_pipe,
        uut_central.tracklet_processing.TPROJ_F1D5F2D5_L2D4.data_in_dly
        );
        $fwrite(fdoProjD5D5MinusD4, "%x %x %x %x %x %x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_L1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_L1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_L1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_L2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_L2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToMinus_F1D5F2D5_L2.data_in_dly
        );  
        // projections to plus sector
        $fwrite(fdoProjD5D5PlusD4, "%x %x %x %x %x %x x x x x x x\n",
        uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_L1.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_L1.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_L1.data_in_dly,
        uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_L2.wr_en,
        uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_L2.BX_pipe,
        uut_central.tracklet_processing.TPROJ_ToPlus_F1D5F2D5_L2.data_in_dly
        );  
        
        
        $fwrite(fdoMatchOrigD4, "%x %x %x x x x x x x x x x\n",
        // matches in original sector
        uut_central.tracklet_processing.FM_L1L2_L3D4.wr_en,
        uut_central.tracklet_processing.FM_L1L2_L3D4.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_L3D4.data_in_dly2
        );    
        
              
        $fwrite(fdoMatchToPlusD4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
        // matches in plus neighbor   
        uut_minus.tracklet_processing.FM_L1L2_L3D4_ToPlus.wr_en,
        uut_minus.tracklet_processing.FM_L1L2_L3D4_ToPlus.BX_pipe,
        uut_minus.tracklet_processing.FM_L1L2_L3D4_ToPlus.data_in_dly2,
        uut_minus.tracklet_processing.FM_L1L2_L4D4_ToPlus.wr_en,
        uut_minus.tracklet_processing.FM_L1L2_L4D4_ToPlus.BX_pipe,
        uut_minus.tracklet_processing.FM_L1L2_L4D4_ToPlus.data_in_dly2, 
        uut_minus.tracklet_processing.FM_L1L2_L5D4_ToPlus.wr_en,
        uut_minus.tracklet_processing.FM_L1L2_L5D4_ToPlus.BX_pipe,
        uut_minus.tracklet_processing.FM_L1L2_L5D4_ToPlus.data_in_dly2,
        uut_minus.tracklet_processing.FM_L1L2_L6D4_ToPlus.wr_en,
        uut_minus.tracklet_processing.FM_L1L2_L6D4_ToPlus.BX_pipe,
        uut_minus.tracklet_processing.FM_L1L2_L6D4_ToPlus.data_in_dly2
        );      
        
        $fwrite(fdoMatchToMinusD4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
        // matches in minus neighbor
        uut_plus.tracklet_processing.FM_L1L2_L3D4_ToMinus.wr_en,
        uut_plus.tracklet_processing.FM_L1L2_L3D4_ToMinus.BX_pipe,
        uut_plus.tracklet_processing.FM_L1L2_L3D4_ToMinus.data_in_dly2,
        uut_plus.tracklet_processing.FM_L1L2_L4D4_ToMinus.wr_en,
        uut_plus.tracklet_processing.FM_L1L2_L4D4_ToMinus.BX_pipe,
        uut_plus.tracklet_processing.FM_L1L2_L4D4_ToMinus.data_in_dly2,             
        uut_plus.tracklet_processing.FM_L1L2_L5D4_ToMinus.wr_en,
        uut_plus.tracklet_processing.FM_L1L2_L5D4_ToMinus.BX_pipe,
        uut_plus.tracklet_processing.FM_L1L2_L5D4_ToMinus.data_in_dly2,             
        uut_plus.tracklet_processing.FM_L1L2_L6D4_ToMinus.wr_en,
        uut_plus.tracklet_processing.FM_L1L2_L6D4_ToMinus.BX_pipe,
        uut_plus.tracklet_processing.FM_L1L2_L6D4_ToMinus.data_in_dly2
        );      
                
        $fwrite(fdoMatchOrigD4_F1F2, "%x %x %x %x %x %x x x x x x x\n",
        // matches in original sector
        uut_central.tracklet_processing.FM_F1F2_L1D4.wr_en,
        uut_central.tracklet_processing.FM_F1F2_L1D4.BX_pipe,
        uut_central.tracklet_processing.FM_F1F2_L1D4.data_in_dly2,
        uut_central.tracklet_processing.FM_F1F2_L2D4.wr_en,
        uut_central.tracklet_processing.FM_F1F2_L2D4.BX_pipe,
        uut_central.tracklet_processing.FM_F1F2_L2D4.data_in_dly2
        );
     
        $fwrite(fdoMatchFromPlusD4_F1F2, "%x %x %x %x %x x x x x x x x\n",    
        // matches from plus neighbor
        uut_central.tracklet_processing.FM_F1F2_L1_FromPlus.wr_en,
        uut_central.tracklet_processing.FM_F1F2_L1_FromPlus.BX_pipe,
        uut_central.tracklet_processing.FM_F1F2_L1_FromPlus.data_in_dly2,
        uut_central.tracklet_processing.FM_F1F2_L2_FromPlus.wr_en,
        uut_central.tracklet_processing.FM_F1F2_L2_FromPlus.BX_pipe,
        uut_central.tracklet_processing.FM_F1F2_L2_FromPlus.data_in_dly2
        );               
                 
        $fwrite(fdoMatchFromMinusD4_F1F2, "%x %x %x %x %x %x x x x x x x\n",    
        // matches from minus neighbor
        uut_central.tracklet_processing.FM_F1F2_L1_FromMinus.wr_en,
        uut_central.tracklet_processing.FM_F1F2_L1_FromMinus.BX_pipe,
        uut_central.tracklet_processing.FM_F1F2_L1_FromMinus.data_in_dly2,
        uut_central.tracklet_processing.FM_F1F2_L2_FromMinus.wr_en,
        uut_central.tracklet_processing.FM_F1F2_L2_FromMinus.BX_pipe,
        uut_central.tracklet_processing.FM_F1F2_L2_FromMinus.data_in_dly2
        );

        $fwrite(fdoMatchOrigD5_L1L2, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        // matches in original sector
        uut_central.tracklet_processing.FM_L1L2_F1D5.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F1D5.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F1D5.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F2D5.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F2D5.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F2D5.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F3D5.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F3D5.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F3D5.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F4D5.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F4D5.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F4D5.data_in_dly2        
        );    

        $fwrite(fdoMatchOrigD6_L1L2, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
        // matches in original sector
        uut_central.tracklet_processing.FM_L1L2_F1D6.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F1D6.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F1D6.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F2D6.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F2D6.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F2D6.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F3D6.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F3D6.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F3D6.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F4D6.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F4D6.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F4D6.data_in_dly2 
        );            
              
        $fwrite(fdoMatchFromPlusD5D6_L1L2, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
        // matches from plus neighbor to D5 or D6  
        uut_central.tracklet_processing.FM_L1L2_F1_FromPlus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F1_FromPlus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F1_FromPlus.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F2_FromPlus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F2_FromPlus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F2_FromPlus.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F3_FromPlus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F3_FromPlus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F3_FromPlus.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F4_FromPlus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F4_FromPlus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F4_FromPlus.data_in_dly2  
        );      
        
        $fwrite(fdoMatchFromMinusD5D6_L1L2, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
        // matches from minus neighbor to D5 or D6
        uut_central.tracklet_processing.FM_L1L2_F1_FromMinus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F1_FromMinus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F1_FromMinus.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F2_FromMinus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F2_FromMinus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F2_FromMinus.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F3_FromMinus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F3_FromMinus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F3_FromMinus.data_in_dly2,
        uut_central.tracklet_processing.FM_L1L2_F4_FromMinus.wr_en,
        uut_central.tracklet_processing.FM_L1L2_F4_FromMinus.BX_pipe,
        uut_central.tracklet_processing.FM_L1L2_F4_FromMinus.data_in_dly2  
        ); 
   
   end
   */
   
   // --------------------------------------------------------------------------------
   // D3 PROJECT 
   // --------------------------------------------------------------------------------
   
    always @(posedge clk) begin
    
    $fwrite(fdo, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    // stub pairs
    uut_central.tracklet_processing.TC_L1D3L2D3.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L1D3L2D3.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L1D3L2D3.innerallstubin,
    uut_central.tracklet_processing.TC_L1D3L2D3.outerallstubin,  
    // tracklet parameters
    uut_central.tracklet_processing.TPAR_L1D3L2D3.enable,
    uut_central.tracklet_processing.TPAR_L1D3L2D3.BX_pipe,
    uut_central.tracklet_processing.TPAR_L1D3L2D3.data_in,
    // track fit
    uut_central.tracklet_processing.FT_L1L2.valid_fit,
    uut_central.tracklet_processing.FT_L1L2.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L1L2.trackout,
    // clean track
    uut_central.tracklet_processing.CT_L1L2.enable,
    uut_central.tracklet_processing.CT_L1L2.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L1L2.data_in
    );
            
    $fwrite(fdo_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    // stub pairs
    uut_central.tracklet_processing.TC_L3D3L4D3.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L3D3L4D3.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L3D3L4D3.innerallstubin,
    uut_central.tracklet_processing.TC_L3D3L4D3.outerallstubin,  
    // tracklet parameters
    uut_central.tracklet_processing.TPAR_L3D3L4D3.enable,
    uut_central.tracklet_processing.TPAR_L3D3L4D3.BX_pipe,
    uut_central.tracklet_processing.TPAR_L3D3L4D3.data_in,
    // track fit
    uut_central.tracklet_processing.FT_L3L4.valid_fit,
    uut_central.tracklet_processing.FT_L3L4.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L3L4.trackout,
    // clean track
    uut_central.tracklet_processing.CT_L3L4.enable,
    uut_central.tracklet_processing.CT_L3L4.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L3L4.data_in
    );
    $fwrite(fdo_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    // stub pairs
    uut_central.tracklet_processing.TC_L5D3L6D3.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L5D3L6D3.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L5D3L6D3.innerallstubin,
    uut_central.tracklet_processing.TC_L5D3L6D3.outerallstubin,  
    // tracklet parameters
    uut_central.tracklet_processing.TPAR_L5D3L6D3.enable,
    uut_central.tracklet_processing.TPAR_L5D3L6D3.BX_pipe,
    uut_central.tracklet_processing.TPAR_L5D3L6D3.data_in,
    // track fit
    uut_central.tracklet_processing.FT_L5L6.valid_fit,
    uut_central.tracklet_processing.FT_L5L6.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L5L6.trackout,
    // clean track
    uut_central.tracklet_processing.CT_L5L6.enable,
    uut_central.tracklet_processing.CT_L5L6.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L5L6.data_in
    );
     end
   
    // --------------------------------------------------------------------------------
    // FOR D3D4 PROJECT -- SEEDING IN D3+D4
    // --------------------------------------------------------------------------------

    always @(posedge clk) begin
    $fwrite(fdoD3D4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TC_L1D3L2D4.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L1D3L2D4.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L1D3L2D4.innerallstubin,
    uut_central.tracklet_processing.TC_L1D3L2D4.outerallstubin,  
    uut_central.tracklet_processing.TPAR_L1D3L2D4.enable,
    uut_central.tracklet_processing.TPAR_L1D3L2D4.BX_pipe,
    uut_central.tracklet_processing.TPAR_L1D3L2D4.data_in,
    uut_central.tracklet_processing.FT_L1L2.valid_fit,
    uut_central.tracklet_processing.FT_L1L2.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L1L2.trackout,
    uut_central.tracklet_processing.CT_L1L2.enable,
    uut_central.tracklet_processing.CT_L1L2.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L1L2.data_out
    );
    $fwrite(fdoD3D4_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TC_L3D3L4D4.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L3D3L4D4.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L3D3L4D4.innerallstubin,
    uut_central.tracklet_processing.TC_L3D3L4D4.outerallstubin,  
    uut_central.tracklet_processing.TPAR_L3D3L4D4.enable,
    uut_central.tracklet_processing.TPAR_L3D3L4D4.BX_pipe,
    uut_central.tracklet_processing.TPAR_L3D3L4D4.data_in,
    uut_central.tracklet_processing.FT_L3L4.valid_fit,
    uut_central.tracklet_processing.FT_L3L4.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L3L4.trackout,
    uut_central.tracklet_processing.CT_L3L4.enable,
    uut_central.tracklet_processing.CT_L3L4.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L3L4.data_in
    );
    $fwrite(fdoD3D4_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TC_L5D3L6D4.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L5D3L6D4.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L5D3L6D4.innerallstubin,
    uut_central.tracklet_processing.TC_L5D3L6D4.outerallstubin,  
    uut_central.tracklet_processing.TPAR_L5D3L6D4.enable,
    uut_central.tracklet_processing.TPAR_L5D3L6D4.BX_pipe,
    uut_central.tracklet_processing.TPAR_L5D3L6D4.data_in,
    uut_central.tracklet_processing.FT_L5L6.valid_fit,
    uut_central.tracklet_processing.FT_L5L6.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L5L6.trackout,
    uut_central.tracklet_processing.CT_L5L6.enable,
    uut_central.tracklet_processing.CT_L5L6.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L5L6.data_in
    );
    // FOR D3D4 PROJECT -- SEEDING IN D4+D4
    $fwrite(fdoD4D4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TC_L1D4L2D4.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L1D4L2D4.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L1D4L2D4.innerallstubin,
    uut_central.tracklet_processing.TC_L1D4L2D4.outerallstubin,  
    uut_central.tracklet_processing.TPAR_L1D4L2D4.enable,
    uut_central.tracklet_processing.TPAR_L1D4L2D4.BX_pipe,
    uut_central.tracklet_processing.TPAR_L1D4L2D4.data_in,
    uut_central.tracklet_processing.FT_L1L2.valid_fit,
    uut_central.tracklet_processing.FT_L1L2.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L1L2.trackout,
    uut_central.tracklet_processing.CT_L1L2.enable,
    uut_central.tracklet_processing.CT_L1L2.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L1L2.data_in
    );
    $fwrite(fdoD4D4_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TC_L3D4L4D4.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L3D4L4D4.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L3D4L4D4.innerallstubin,
    uut_central.tracklet_processing.TC_L3D4L4D4.outerallstubin,  
    uut_central.tracklet_processing.TPAR_L3D4L4D4.enable,
    uut_central.tracklet_processing.TPAR_L3D4L4D4.BX_pipe,
    uut_central.tracklet_processing.TPAR_L3D4L4D4.data_in,
    uut_central.tracklet_processing.FT_L3L4.valid_fit,
    uut_central.tracklet_processing.FT_L3L4.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L3L4.trackout,
    uut_central.tracklet_processing.CT_L3L4.enable,
    uut_central.tracklet_processing.CT_L3L4.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L3L4.data_in
    );
    $fwrite(fdoD4D4_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TC_L5D4L6D4.pre_valid_trackpar,
    uut_central.tracklet_processing.TC_L5D4L6D4.BX_pipe-3'b111,
    uut_central.tracklet_processing.TC_L5D4L6D4.innerallstubin,
    uut_central.tracklet_processing.TC_L5D4L6D4.outerallstubin,  
    uut_central.tracklet_processing.TPAR_L5D4L6D4.enable,
    uut_central.tracklet_processing.TPAR_L5D4L6D4.BX_pipe,
    uut_central.tracklet_processing.TPAR_L5D4L6D4.data_in,
    uut_central.tracklet_processing.FT_L5L6.valid_fit,
    uut_central.tracklet_processing.FT_L5L6.BX_pipe-3'b111,
    uut_central.tracklet_processing.FT_L5L6.trackout,
    uut_central.tracklet_processing.CT_L5L6.enable,
    uut_central.tracklet_processing.CT_L5L6.BX_pipe-3'b111,
    uut_central.tracklet_processing.CT_L5L6.data_in
    );
    
    end
    
    // new files to avoid huge output files 
    // next few files keep: TProjections, AllProjections, AllMatches in Original Sector
    // and then AllMatch that are to be sent to the Plus/Minus neighbor
    // Note: keeping BX_pipe for each memory is redundant, but kept for completeness
    always @(posedge clk) begin
    // projections directly out of the Tracklet Calculator
    // split into files depending on wether they are sent to the original (Orig) sector
    // or the Plus/Minus neighbors
    
    $fwrite(fdoProjOrig, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L3D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L3D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L3D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L4D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L4D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L4D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L5D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L5D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L5D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L6D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L6D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L1D3L2D3_L6D3.data_in_dly
    );
    $fwrite(fdoProjMinus, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L3.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L4.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L4.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L4.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L5.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L5.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L5.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L6.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L6.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D3_L6.data_in_dly        
    );
    $fwrite(fdoProjPlus, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L3.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L4.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L4.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L4.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L5.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L5.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L5.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L6.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L6.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D3_L6.data_in_dly            
    );

    // PROJECTIONS FOR L3+L4 tracklets
    $fwrite(fdoProjOrig_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L1D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L1D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L1D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L2D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L2D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L2D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L5D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L5D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L5D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L6D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L6D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L3D3L4D3_L6D3.data_in_dly
    );
    $fwrite(fdoProjMinus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L1.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L1.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L1.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L2.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L2.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L2.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L5.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L5.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L5.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L6.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L6.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D3_L6.data_in_dly        
    );
    $fwrite(fdoProjPlus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L1.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L1.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L1.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L2.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L2.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L2.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L5.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L5.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L5.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L6.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L6.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D3_L6.data_in_dly            
    );

    // PROJECTIONS FOR L5+L6 tracklets
    $fwrite(fdoProjOrig_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L1D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L1D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L1D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L2D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L2D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L2D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L3D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L3D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L3D3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L4D3.wr_en,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L4D3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_L5D3L6D3_L4D3.data_in_dly
    );
    $fwrite(fdoProjMinus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L1.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L1.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L1.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L2.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L2.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L2.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L3.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L4.wr_en,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L4.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D3_L4.data_in_dly        
    );
    $fwrite(fdoProjPlus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L1.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L1.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L1.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L2.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L2.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L2.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L3.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L3.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L3.data_in_dly,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L4.wr_en,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L4.BX_pipe,
    uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D3_L4.data_in_dly            
    );
    
    
    
     // ----------------------------------------------------------------------
     // FOR D3D4 PROJECT 
     // tracklet seeded in D3+D3, projecting to D4
     $fwrite(fdoProjOrigD4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L3D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L3D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L3D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L4D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L4D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L4D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L5D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L5D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L5D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L6D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L6D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D3L2D3_L6D4.data_in_dly
     );
     $fwrite(fdoProjOrigD4_L3L4, "x x x x x x %x %x %x %x %x %x\n",
     //uut_central.tracklet_processing.TPROJ_L3D3L4D3_L1D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D3_L1D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D3_L1D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D3_L2D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D3_L2D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D3_L2D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D3L4D3_L5D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D3L4D3_L5D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D3L4D3_L5D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D3L4D3_L6D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D3L4D3_L6D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D3L4D3_L6D4.data_in_dly
     );
     // tracklets seeded in D3+D4, projecting to D3 
     $fwrite(fdoProjD3D4Orig_L3L4, "%x %x %x %x %x %x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L1D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L1D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L1D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L2D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L2D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L2D3.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L5D3.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L5D3.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L5D3.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L6D3.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L6D3.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L6D3.data_in_dly
     );        
     $fwrite(fdoProjD3D4Orig_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L1D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L1D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L1D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L2D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L2D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L2D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L3D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L3D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L3D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L4D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L4D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D3L6D4_L4D3.data_in_dly
     );        
     // tracklets seeded in D3+D4, projecting to D4
     $fwrite(fdoProjD3D4OrigD4, "%x %x %x %x %x %x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_L1D3L2D4_L3D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D3L2D4_L3D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D3L2D4_L3D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L1D3L2D4_L4D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D3L2D4_L4D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D3L2D4_L4D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L1D3L2D4_L5D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L1D3L2D4_L5D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L1D3L2D4_L5D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L1D3L2D4_L6D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L1D3L2D4_L6D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L1D3L2D4_L6D4.data_in_dly
     );        
     $fwrite(fdoProjD3D4OrigD4_L3L4, "x x x x x x %x %x %x %x %x %x\n",
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L1D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L1D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L1D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L2D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L2D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D3L4D4_L2D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L5D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L5D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L5D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L6D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L6D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D3L4D4_L6D4.data_in_dly
     );        
     // trackletsseed in D4+D4, projecting to D3
     $fwrite(fdoProjD4D4Orig_L3L4, "%x %x %x %x %x %x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D3.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D3.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D3.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D3.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D3.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D3.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D3.data_in_dly
     );
     $fwrite(fdoProjD4D4Orig_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D3.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D3.data_in_dly
     );
     // tracklets seeded in D4+D4, projecting to D4
     $fwrite(fdoProjD4D4OrigD4, "%x %x %x x x x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_L1D4L2D4_L3D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L1D4L2D4_L3D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L1D4L2D4_L3D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L4D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L4D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L4D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L5D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L5D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L5D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L6D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L6D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L1D4L2D4_L6D4.data_in_dly
     );
     $fwrite(fdoProjD4D4OrigD4_L3L4, "x x x %x %x %x %x %x %x %x %x %x\n",
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L3D4L4D4_L1D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L2D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L5D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L3D4L4D4_L6D4.data_in_dly
     );
     $fwrite(fdoProjD4D4OrigD4_L5L6, "x x x x x x %x %x %x %x %x %x\n",
     //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L1D4.data_in_dly,
     //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D4.wr_en,
     //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D4.BX_pipe,
     //uut_central.tracklet_processing.TPROJ_L5D4L6D4_L2D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L3D4.data_in_dly,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D4.wr_en,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_L5D4L6D4_L4D4.data_in_dly
     );
     
     // tracklets seeded in D3+D4, projecting to minus/plus sectors
     $fwrite(fdoProjD3D4Minus, "%x %x %x %x %x %x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L4.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L4.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L5.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L5.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L5.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L6.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L6.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D3L2D4_L6.data_in_dly        
     );
     $fwrite(fdoProjD3D4Minus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L5.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L5.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L5.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L6.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L6.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D3L4D4_L6.data_in_dly        
     );
     $fwrite(fdoProjD3D4Minus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L4.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D3L6D4_L4.data_in_dly        
     );
     
     $fwrite(fdoProjD3D4Plus, "%x %x %x %x %x %x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L4.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L4.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L5.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L5.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L5.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L6.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L6.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D3L2D4_L6.data_in_dly            
     );
     $fwrite(fdoProjD3D4Plus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L5.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L5.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L5.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L6.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L6.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D3L4D4_L6.data_in_dly            
     );
     $fwrite(fdoProjD3D4Plus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L4.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D3L6D4_L4.data_in_dly            
     );
     
     // tracklets seeded in D4+D4, projecting to minus/plus sectors
     $fwrite(fdoProjD4D4Minus, "%x %x %x x x x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L3.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L4.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L4.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L4.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L5.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L5.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L5.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L6.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L6.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToMinus_L1D4L2D4_L6.data_in_dly        
     );
     $fwrite(fdoProjD4D4Minus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L5.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L5.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L5.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L6.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L6.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L3D4L4D4_L6.data_in_dly        
     );
     $fwrite(fdoProjD4D4Minus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L4.wr_en,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToMinus_L5D4L6D4_L4.data_in_dly        
     );

     $fwrite(fdoProjD4D4Plus, "%x %x %x x x x x x x x x x\n",
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L3.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L4.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L4.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L4.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L5.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L5.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L5.data_in_dly,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L6.wr_en,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L6.BX_pipe,
//     uut_central.tracklet_processing.TPROJ_ToPlus_L1D4L2D4_L6.data_in_dly            
     );
     $fwrite(fdoProjD4D4Plus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L5.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L5.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L5.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L6.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L6.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L3D4L4D4_L6.data_in_dly            
     );
     $fwrite(fdoProjD4D4Plus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L1.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L1.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L1.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L2.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L2.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L2.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L3.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L3.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L3.data_in_dly,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L4.wr_en,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L4.BX_pipe,
     uut_central.tracklet_processing.TPROJ_ToPlus_L5D4L6D4_L4.data_in_dly            
     );
     // ----------------------------------------------------------------------
     
    end
     
     //    always @(posedge clk) begin
     //        $fwrite(fdoAllProj, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     //        // projections 
     //        // Note: projections (prev. length 54bits) have additional bits [55:54] 
     //        // that keep track of where the projection has originated (orig/plus/minus)
     //        uut_central.tracklet_processing.AP_L1L2_L3D3.enable,
     //        uut_central.tracklet_processing.AP_L1L2_L3D3.BX_pipe, 
     //        uut_central.tracklet_processing.AP_L1L2_L3D3.data_in,
     //        uut_central.tracklet_processing.AP_L1L2_L4D3.enable,
     //        uut_central.tracklet_processing.AP_L1L2_L4D3.BX_pipe,
     //        uut_central.tracklet_processing.AP_L1L2_L4D3.data_in,
     //        uut_central.tracklet_processing.AP_L1L2_L5D3.enable,
     //        uut_central.tracklet_processing.AP_L1L2_L5D3.BX_pipe,
     //        uut_central.tracklet_processing.AP_L1L2_L5D3.data_in,
     //        uut_central.tracklet_processing.AP_L1L2_L6D3.enable,
     //        uut_central.tracklet_processing.AP_L1L2_L6D3.BX_pipe,
     //        uut_central.tracklet_processing.AP_L1L2_L6D3.data_in
     //        );
     //    end
     
     always @(posedge clk) begin
     
     $fwrite(fdoMatchOrig, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     // matches in original sector
     // matches for L1L2_L3
     uut_central.tracklet_processing.FM_L1L2_L3D3.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L3D3.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L3D3.data_in_dly2,
     // matches for L1L2_L4 
     uut_central.tracklet_processing.FM_L1L2_L4D3.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L4D3.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L4D3.data_in_dly2,            
     // matches for L1L2_L5
     uut_central.tracklet_processing.FM_L1L2_L5D3.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L5D3.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L5D3.data_in_dly2,            
     // matches for L1L2_L6
     uut_central.tracklet_processing.FM_L1L2_L6D3.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L6D3.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L6D3.data_in_dly2
     );
     $fwrite(fdoMatchToMinus, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
     // matches in minus neighbor
     uut_plus.tracklet_processing.FM_L1L2_L3D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L1L2_L3D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L1L2_L3D3_ToMinus.data_in_dly2,
     uut_plus.tracklet_processing.FM_L1L2_L4D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L1L2_L4D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L1L2_L4D3_ToMinus.data_in_dly2,             
     uut_plus.tracklet_processing.FM_L1L2_L5D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L1L2_L5D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L1L2_L5D3_ToMinus.data_in_dly2,             
     uut_plus.tracklet_processing.FM_L1L2_L6D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L1L2_L6D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L1L2_L6D3_ToMinus.data_in_dly2
     );
     $fwrite(fdoMatchToPlus, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
     // matches in plus neighbor   
     uut_minus.tracklet_processing.FM_L1L2_L3D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L1L2_L3D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L1L2_L3D3_ToPlus.data_in_dly2,
     uut_minus.tracklet_processing.FM_L1L2_L4D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L1L2_L4D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L1L2_L4D3_ToPlus.data_in_dly2, 
     uut_minus.tracklet_processing.FM_L1L2_L5D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L1L2_L5D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L1L2_L5D3_ToPlus.data_in_dly2,
     uut_minus.tracklet_processing.FM_L1L2_L6D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L1L2_L6D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L1L2_L6D3_ToPlus.data_in_dly2
     );
     $fwrite(fdoMatchFromMinus, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
     // matches in minus neighbor
     uut_central.tracklet_processing.FM_L1L2_L3_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L3_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L3_FromMinus.data_in_dly2,
     uut_central.tracklet_processing.FM_L1L2_L4_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L4_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L4_FromMinus.data_in_dly2,             
     uut_central.tracklet_processing.FM_L1L2_L5_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L5_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L5_FromMinus.data_in_dly2,             
     uut_central.tracklet_processing.FM_L1L2_L6_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L6_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L6_FromMinus.data_in_dly2
     );
     $fwrite(fdoMatchFromPlus, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
     // matches in plus neighbor   
     uut_central.tracklet_processing.FM_L1L2_L3_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L3_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L3_FromPlus.data_in_dly2,
     uut_central.tracklet_processing.FM_L1L2_L4_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L4_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L4_FromPlus.data_in_dly2, 
     uut_central.tracklet_processing.FM_L1L2_L5_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L5_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L5_FromPlus.data_in_dly2,
     uut_central.tracklet_processing.FM_L1L2_L6_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L1L2_L6_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L1L2_L6_FromPlus.data_in_dly2
     );

     // MATCHES FOR L3+L4 TRACKLETS
     $fwrite(fdoMatchOrig_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     // matches in original sector
     uut_central.tracklet_processing.FM_L3L4_L1D3.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L1D3.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L1D3.data_in_dly2,
     uut_central.tracklet_processing.FM_L3L4_L2D3.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L2D3.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L2D3.data_in_dly2,            
     uut_central.tracklet_processing.FM_L3L4_L5D3.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L5D3.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L5D3.data_in_dly2,            
     uut_central.tracklet_processing.FM_L3L4_L6D3.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L6D3.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L6D3.data_in_dly2
     );
     $fwrite(fdoMatchToMinus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
     // matches in minus neighbor
     uut_plus.tracklet_processing.FM_L3L4_L1D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L3L4_L1D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L3L4_L1D3_ToMinus.data_in_dly2,
     uut_plus.tracklet_processing.FM_L3L4_L2D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L3L4_L2D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L3L4_L2D3_ToMinus.data_in_dly2,             
     uut_plus.tracklet_processing.FM_L3L4_L5D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L3L4_L5D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L3L4_L5D3_ToMinus.data_in_dly2,             
     uut_plus.tracklet_processing.FM_L3L4_L6D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L3L4_L6D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L3L4_L6D3_ToMinus.data_in_dly2
     );
     $fwrite(fdoMatchToPlus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
     // matches in plus neighbor   
     uut_minus.tracklet_processing.FM_L3L4_L1D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L3L4_L1D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L3L4_L1D3_ToPlus.data_in_dly2,
     uut_minus.tracklet_processing.FM_L3L4_L2D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L3L4_L2D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L3L4_L2D3_ToPlus.data_in_dly2, 
     uut_minus.tracklet_processing.FM_L3L4_L5D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L3L4_L5D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L3L4_L5D3_ToPlus.data_in_dly2,
     uut_minus.tracklet_processing.FM_L3L4_L6D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L3L4_L6D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L3L4_L6D3_ToPlus.data_in_dly2
     );
     $fwrite(fdoMatchFromMinus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
     // matches in minus neighbor
     uut_central.tracklet_processing.FM_L3L4_L1_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L1_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L1_FromMinus.data_in_dly2,
     uut_central.tracklet_processing.FM_L3L4_L2_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L2_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L2_FromMinus.data_in_dly2,             
     uut_central.tracklet_processing.FM_L3L4_L5_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L5_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L5_FromMinus.data_in_dly2,             
     uut_central.tracklet_processing.FM_L3L4_L6_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L6_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L6_FromMinus.data_in_dly2
     );
     $fwrite(fdoMatchFromPlus_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
     // matches in plus neighbor   
     uut_central.tracklet_processing.FM_L3L4_L1_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L1_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L1_FromPlus.data_in_dly2,
     uut_central.tracklet_processing.FM_L3L4_L2_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L2_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L2_FromPlus.data_in_dly2, 
     uut_central.tracklet_processing.FM_L3L4_L5_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L5_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L5_FromPlus.data_in_dly2,
     uut_central.tracklet_processing.FM_L3L4_L6_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L3L4_L6_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L3L4_L6_FromPlus.data_in_dly2
     );
     

     // MATCHES FOR L5+L6 TRACKLETS
     
     $fwrite(fdoMatchOrig_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
     // matches in original sector
     uut_central.tracklet_processing.FM_L5L6_L1D3.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L1D3.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L1D3.data_in_dly2,
     uut_central.tracklet_processing.FM_L5L6_L2D3.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L2D3.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L2D3.data_in_dly2,            
     uut_central.tracklet_processing.FM_L5L6_L3D3.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L3D3.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L3D3.data_in_dly2,            
     uut_central.tracklet_processing.FM_L5L6_L4D3.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L4D3.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L4D3.data_in_dly2
     );
     $fwrite(fdoMatchToMinus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
     // matches in minus neighbor
     uut_plus.tracklet_processing.FM_L5L6_L1D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L5L6_L1D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L5L6_L1D3_ToMinus.data_in_dly2,
     uut_plus.tracklet_processing.FM_L5L6_L2D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L5L6_L2D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L5L6_L2D3_ToMinus.data_in_dly2,             
     uut_plus.tracklet_processing.FM_L5L6_L3D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L5L6_L3D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L5L6_L3D3_ToMinus.data_in_dly2,             
     uut_plus.tracklet_processing.FM_L5L6_L4D3_ToMinus.wr_en,
     uut_plus.tracklet_processing.FM_L5L6_L4D3_ToMinus.BX_pipe,
     uut_plus.tracklet_processing.FM_L5L6_L4D3_ToMinus.data_in_dly2
     );
     $fwrite(fdoMatchToPlus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
     // matches in plus neighbor   
     uut_minus.tracklet_processing.FM_L5L6_L1D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L5L6_L1D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L5L6_L1D3_ToPlus.data_in_dly2,
     uut_minus.tracklet_processing.FM_L5L6_L2D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L5L6_L2D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L5L6_L2D3_ToPlus.data_in_dly2, 
     uut_minus.tracklet_processing.FM_L5L6_L3D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L5L6_L3D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L5L6_L3D3_ToPlus.data_in_dly2,
     uut_minus.tracklet_processing.FM_L5L6_L4D3_ToPlus.wr_en,
     uut_minus.tracklet_processing.FM_L5L6_L4D3_ToPlus.BX_pipe,
     uut_minus.tracklet_processing.FM_L5L6_L4D3_ToPlus.data_in_dly2
     );
     $fwrite(fdoMatchFromMinus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
     // matches in minus neighbor
     uut_central.tracklet_processing.FM_L5L6_L1_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L1_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L1_FromMinus.data_in_dly2,
     uut_central.tracklet_processing.FM_L5L6_L2_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L2_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L2_FromMinus.data_in_dly2,             
     uut_central.tracklet_processing.FM_L5L6_L3_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L3_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L3_FromMinus.data_in_dly2,             
     uut_central.tracklet_processing.FM_L5L6_L4_FromMinus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L4_FromMinus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L4_FromMinus.data_in_dly2
     );
     $fwrite(fdoMatchFromPlus_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
     // matches in plus neighbor   
     uut_central.tracklet_processing.FM_L5L6_L1_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L1_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L1_FromPlus.data_in_dly2,
     uut_central.tracklet_processing.FM_L5L6_L2_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L2_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L2_FromPlus.data_in_dly2, 
     uut_central.tracklet_processing.FM_L5L6_L3_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L3_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L3_FromPlus.data_in_dly2,
     uut_central.tracklet_processing.FM_L5L6_L4_FromPlus.wr_en,
     uut_central.tracklet_processing.FM_L5L6_L4_FromPlus.BX_pipe,
     uut_central.tracklet_processing.FM_L5L6_L4_FromPlus.data_in_dly2
     );
     
     
      // FOR D3D4 PROJECT (seeding in D3 only still, but matches from D4)
      $fwrite(fdoMatchOrigD4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
      // matches in original sector
      uut_central.tracklet_processing.FM_L1L2_L3D4.wr_en,
      uut_central.tracklet_processing.FM_L1L2_L3D4.BX_pipe,
      uut_central.tracklet_processing.FM_L1L2_L3D4.data_in_dly2,
      uut_central.tracklet_processing.FM_L1L2_L4D4.wr_en,
      uut_central.tracklet_processing.FM_L1L2_L4D4.BX_pipe,
      uut_central.tracklet_processing.FM_L1L2_L4D4.data_in_dly2,            
      uut_central.tracklet_processing.FM_L1L2_L5D4.wr_en,
      uut_central.tracklet_processing.FM_L1L2_L5D4.BX_pipe,
      uut_central.tracklet_processing.FM_L1L2_L5D4.data_in_dly2,            
      uut_central.tracklet_processing.FM_L1L2_L6D4.wr_en,
      uut_central.tracklet_processing.FM_L1L2_L6D4.BX_pipe,
      uut_central.tracklet_processing.FM_L1L2_L6D4.data_in_dly2
      );
      $fwrite(fdoMatchOrigD4_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
      // matches in original sector
      uut_central.tracklet_processing.FM_L3L4_L1D4.wr_en,
      uut_central.tracklet_processing.FM_L3L4_L1D4.BX_pipe,
      uut_central.tracklet_processing.FM_L3L4_L1D4.data_in_dly2,
      uut_central.tracklet_processing.FM_L3L4_L2D4.wr_en,
      uut_central.tracklet_processing.FM_L3L4_L2D4.BX_pipe,
      uut_central.tracklet_processing.FM_L3L4_L2D4.data_in_dly2,            
      uut_central.tracklet_processing.FM_L3L4_L5D4.wr_en,
      uut_central.tracklet_processing.FM_L3L4_L5D4.BX_pipe,
      uut_central.tracklet_processing.FM_L3L4_L5D4.data_in_dly2,            
      uut_central.tracklet_processing.FM_L3L4_L6D4.wr_en,
      uut_central.tracklet_processing.FM_L3L4_L6D4.BX_pipe,
      uut_central.tracklet_processing.FM_L3L4_L6D4.data_in_dly2
      );
      $fwrite(fdoMatchOrigD4_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",
      // matches in original sector
      uut_central.tracklet_processing.FM_L5L6_L1D4.wr_en,
      uut_central.tracklet_processing.FM_L5L6_L1D4.BX_pipe,
      uut_central.tracklet_processing.FM_L5L6_L1D4.data_in_dly2,
      uut_central.tracklet_processing.FM_L5L6_L2D4.wr_en,
      uut_central.tracklet_processing.FM_L5L6_L2D4.BX_pipe,
      uut_central.tracklet_processing.FM_L5L6_L2D4.data_in_dly2,            
      uut_central.tracklet_processing.FM_L5L6_L3D4.wr_en,
      uut_central.tracklet_processing.FM_L5L6_L3D4.BX_pipe,
      uut_central.tracklet_processing.FM_L5L6_L3D4.data_in_dly2,            
      uut_central.tracklet_processing.FM_L5L6_L4D4.wr_en,
      uut_central.tracklet_processing.FM_L5L6_L4D4.BX_pipe,
      uut_central.tracklet_processing.FM_L5L6_L4D4.data_in_dly2
      );

      $fwrite(fdoMatchToMinusD4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
      // matches in minus neighbor
      uut_plus.tracklet_processing.FM_L1L2_L3D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L1L2_L3D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L1L2_L3D4_ToMinus.data_in_dly2,
      uut_plus.tracklet_processing.FM_L1L2_L4D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L1L2_L4D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L1L2_L4D4_ToMinus.data_in_dly2,             
      uut_plus.tracklet_processing.FM_L1L2_L5D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L1L2_L5D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L1L2_L5D4_ToMinus.data_in_dly2,             
      uut_plus.tracklet_processing.FM_L1L2_L6D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L1L2_L6D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L1L2_L6D4_ToMinus.data_in_dly2
      );
      $fwrite(fdoMatchToMinusD4_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
      // matches in minus neighbor
      uut_plus.tracklet_processing.FM_L3L4_L1D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L3L4_L1D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L3L4_L1D4_ToMinus.data_in_dly2,
      uut_plus.tracklet_processing.FM_L3L4_L2D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L3L4_L2D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L3L4_L2D4_ToMinus.data_in_dly2,             
      uut_plus.tracklet_processing.FM_L3L4_L5D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L3L4_L5D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L3L4_L5D4_ToMinus.data_in_dly2,             
      uut_plus.tracklet_processing.FM_L3L4_L6D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L3L4_L6D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L3L4_L6D4_ToMinus.data_in_dly2
      );
      $fwrite(fdoMatchToMinusD4_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",    
      // matches in minus neighbor
      uut_plus.tracklet_processing.FM_L5L6_L1D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L5L6_L1D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L5L6_L1D4_ToMinus.data_in_dly2,
      uut_plus.tracklet_processing.FM_L5L6_L2D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L5L6_L2D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L5L6_L2D4_ToMinus.data_in_dly2,             
      uut_plus.tracklet_processing.FM_L5L6_L3D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L5L6_L3D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L5L6_L3D4_ToMinus.data_in_dly2,             
      uut_plus.tracklet_processing.FM_L5L6_L4D4_ToMinus.wr_en,
      uut_plus.tracklet_processing.FM_L5L6_L4D4_ToMinus.BX_pipe,
      uut_plus.tracklet_processing.FM_L5L6_L4D4_ToMinus.data_in_dly2
      );

      
      $fwrite(fdoMatchToPlusD4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
      // matches in plus neighbor   
      uut_minus.tracklet_processing.FM_L1L2_L3D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L1L2_L3D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L1L2_L3D4_ToPlus.data_in_dly2,
      uut_minus.tracklet_processing.FM_L1L2_L4D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L1L2_L4D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L1L2_L4D4_ToPlus.data_in_dly2, 
      uut_minus.tracklet_processing.FM_L1L2_L5D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L1L2_L5D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L1L2_L5D4_ToPlus.data_in_dly2,
      uut_minus.tracklet_processing.FM_L1L2_L6D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L1L2_L6D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L1L2_L6D4_ToPlus.data_in_dly2
      );
      $fwrite(fdoMatchToPlusD4_L3L4, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
      // matches in plus neighbor   
      uut_minus.tracklet_processing.FM_L3L4_L1D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L3L4_L1D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L3L4_L1D4_ToPlus.data_in_dly2,
      uut_minus.tracklet_processing.FM_L3L4_L2D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L3L4_L2D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L3L4_L2D4_ToPlus.data_in_dly2, 
      uut_minus.tracklet_processing.FM_L3L4_L5D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L3L4_L5D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L3L4_L5D4_ToPlus.data_in_dly2,
      uut_minus.tracklet_processing.FM_L3L4_L6D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L3L4_L6D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L3L4_L6D4_ToPlus.data_in_dly2
      );
      $fwrite(fdoMatchToPlusD4_L5L6, "%x %x %x %x %x %x %x %x %x %x %x %x\n",              
      // matches in plus neighbor   
      uut_minus.tracklet_processing.FM_L5L6_L1D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L5L6_L1D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L5L6_L1D4_ToPlus.data_in_dly2,
      uut_minus.tracklet_processing.FM_L5L6_L2D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L5L6_L2D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L5L6_L2D4_ToPlus.data_in_dly2, 
      uut_minus.tracklet_processing.FM_L5L6_L3D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L5L6_L3D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L5L6_L3D4_ToPlus.data_in_dly2,
      uut_minus.tracklet_processing.FM_L5L6_L4D4_ToPlus.wr_en,
      uut_minus.tracklet_processing.FM_L5L6_L4D4_ToPlus.BX_pipe,
      uut_minus.tracklet_processing.FM_L5L6_L4D4_ToPlus.data_in_dly2
      );
      
    end
    

endmodule
