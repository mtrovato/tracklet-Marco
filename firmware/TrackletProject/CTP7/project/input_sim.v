`timescale 1ns / 1ps

module input_sim(
		 input wire 	   clk,
		 input wire	       reset,
		 input wire	       BC0,
		 output reg [31:0] link1_reg1_minus,
		 output reg [31:0] link1_reg2_minus,
		 output reg [31:0] link2_reg1_minus,
		 output reg [31:0] link2_reg2_minus,
		 output reg [31:0] link3_reg1_minus,
		 output reg [31:0] link3_reg2_minus,
		 output reg [31:0] link1_reg1_central,
		 output reg [31:0] link1_reg2_central,
		 output reg [31:0] link2_reg1_central,
		 output reg [31:0] link2_reg2_central,
		 output reg [31:0] link3_reg1_central,
		 output reg [31:0] link3_reg2_central,
		 output reg [31:0] link1_reg1_plus,
		 output reg [31:0] link1_reg2_plus,
		 output reg [31:0] link2_reg1_plus,
		 output reg [31:0] link2_reg2_plus,
		 output reg [31:0] link3_reg1_plus,
		 output reg [31:0] link3_reg2_plus,

		 // additional inputs for D3D4 project
		 output reg [31:0] link4_reg1_minus,
		 output reg [31:0] link4_reg2_minus,
		 output reg [31:0] link5_reg1_minus,
		 output reg [31:0] link5_reg2_minus,
		 output reg [31:0] link6_reg1_minus,
		 output reg [31:0] link6_reg2_minus,
		 output reg [31:0] link4_reg1_central,
		 output reg [31:0] link4_reg2_central,
		 output reg [31:0] link5_reg1_central,
		 output reg [31:0] link5_reg2_central,
		 output reg [31:0] link6_reg1_central,
		 output reg [31:0] link6_reg2_central,
		 output reg [31:0] link4_reg1_plus,
		 output reg [31:0] link4_reg2_plus,
		 output reg [31:0] link5_reg1_plus,
		 output reg [31:0] link5_reg2_plus,
		 output reg [31:0] link6_reg1_plus,
		 output reg [31:0] link6_reg2_plus,

		 // additional inputs for D4D6 project (3 DTC regions)
		 output reg [31:0] link7_reg1_minus,
		 output reg [31:0] link7_reg2_minus,
		 output reg [31:0] link8_reg1_minus,
		 output reg [31:0] link8_reg2_minus,
		 output reg [31:0] link9_reg1_minus,
		 output reg [31:0] link9_reg2_minus,
		 output reg [31:0] link7_reg1_central,
		 output reg [31:0] link7_reg2_central,
		 output reg [31:0] link8_reg1_central,
		 output reg [31:0] link8_reg2_central,
		 output reg [31:0] link9_reg1_central,
		 output reg [31:0] link9_reg2_central,
		 output reg [31:0] link7_reg1_plus,
		 output reg [31:0] link7_reg2_plus,
		 output reg [31:0] link8_reg1_plus,
		 output reg [31:0] link8_reg2_plus,
		 output reg [31:0] link9_reg1_plus,
		 output reg [31:0] link9_reg2_plus		 
		 );


   reg [50*20:1] 	       str1;
   reg [50*20:1] 	       str2;
   reg [50*20:1] 	       str3;
   reg [50*20:1] 	       str4;
   reg [50*20:1] 	       str5;
   reg [50*20:1] 	       str6;
   reg [50*20:1]           str7;
   reg [50*20:1]           str8;
   reg [50*20:1]           str9;

   // ---------------------------------------------------------
   // inputs
   integer 		       fdi1;
   integer 		       fdi2;
   integer 		       fdi3;
   integer 		       fdi4; //for D3D4 project or D5D6 project
   integer 		       fdi5; //for D3D4 project or D5D6 project
   integer 		       fdi6; //for D3D4 project or D5D6 project
   integer             fdi7; //for D4D6 project (3 DTC regions)
   integer             fdi8; //for D4D6 project (3 DTC regions)
   integer             fdi9; //for D4D6 project (3 DTC regions)
   
   // ---------------------------------------------------------
   //
   integer 		       dummy1;
   integer 		       dummy2;
   integer 		       dummy3;
   integer 		       dummy4;
   integer 		       dummy5;
   integer 		       dummy6;
   integer             dummy7;
   integer             dummy8;
   integer             dummy9;
   integer 		       val1;
   integer 		       val2;
   integer 		       val3;
   integer 		       val4;
   integer 		       val5;
   integer 		       val6;
   integer             val7;
   integer             val8;
   integer             val9;
   reg [31:0] 		       data_link1_0;
   reg [31:0] 		       data_link1_1;
   reg [31:0] 		       data_link2_0;
   reg [31:0] 		       data_link2_1;
   reg [31:0] 		       data_link3_0;
   reg [31:0] 		       data_link3_1;
   reg [31:0] 		       data_link4_0;
   reg [31:0] 		       data_link4_1;
   reg [31:0] 		       data_link5_0;
   reg [31:0] 		       data_link5_1;
   reg [31:0] 		       data_link6_0;
   reg [31:0] 		       data_link6_1;
   reg [31:0] 		       data_link7_0;
   reg [31:0]              data_link7_1;
   reg [31:0] 		       data_link8_0;
   reg [31:0]              data_link8_1;
   reg [31:0] 		       data_link9_0;
   reg [31:0]              data_link9_1;
   reg [31:0] 		       data_link1_02;
   reg [31:0] 		       data_link1_12;
   reg [31:0] 		       data_link2_02;
   reg [31:0] 		       data_link2_12;
   reg [31:0] 		       data_link3_02;
   reg [31:0] 		       data_link3_12;
   reg [31:0] 		       data_link4_02;
   reg [31:0] 		       data_link4_12;
   reg [31:0] 		       data_link5_02;
   reg [31:0] 		       data_link5_12;
   reg [31:0] 		       data_link6_02;
   reg [31:0] 		       data_link6_12;
   reg [31:0] 		       data_link7_02;
   reg [31:0]              data_link7_12;
   reg [31:0] 		       data_link8_02;
   reg [31:0]              data_link8_12;
   reg [31:0] 		       data_link9_02;
   reg [31:0]              data_link9_12;
   reg [31:0] 		       data_link1_03;
   reg [31:0] 		       data_link1_13;
   reg [31:0] 		       data_link2_03;
   reg [31:0] 		       data_link2_13;
   reg [31:0] 		       data_link3_03;
   reg [31:0] 		       data_link3_13;
   reg [31:0] 		       data_link4_03;
   reg [31:0] 		       data_link4_13;
   reg [31:0] 		       data_link5_03;
   reg [31:0] 		       data_link5_13;
   reg [31:0] 		       data_link6_03;
   reg [31:0] 		       data_link6_13;
   reg [31:0] 		       data_link7_03;
   reg [31:0]              data_link7_13;
   reg [31:0] 		       data_link8_03;
   reg [31:0]              data_link8_13;   
   reg [31:0] 		       data_link9_03;
   reg [31:0]              data_link9_13;
   reg [31:0] 		       add_0;
   reg [31:0] 		       add_1;
   
   // start processing
   initial begin
      
      #2 link1_reg1_central = 32'h00003abe;link1_reg2_central = 32'h00003abe;
      #98 link1_reg1_central = 32'h0;link1_reg2_central = 32'h0;

      // Write the data
      #310;
      ////////////////////////////////////////
      // Input from a file
      // fdi1 --> stubs for sector 02
      // fdi2 --> stubs for sector 03
      // fdi3 --> stubs for sector 04
      
      // USE THIS FOR RUNNING THE D3 PROJECT
      // input_1trk_2/3/4     --> single tracks without projections to neighboring sectors
      // input_1trkproj_2/3/4 --> single tracks WITH projections to neighboring sectors
      // input_5trk_2/3/4     --> five tracks without projections to neighboring sectors
      // input_5trkproj_2/3/4 --> five tracks WITH projections to neighboring sectors

//      fdi1 = $fopen("input_1trkproj_2.txt","r");
//      fdi2 = $fopen("input_1trkproj_3.txt","r");
//      fdi3 = $fopen("input_1trkproj_4.txt","r");
      
      // USE THIS FOR RUNNING THE D3D4 project
      // input_1trk_D3/4_2/3/4     --> single tracks without projections to neighboring sectors
      // input_1trkproj_D3/4_2/3/4 --> single tracks WITH projections to neighboring sectors
      
       
       fdi1 = $fopen("input_1trkproj_D3_2.txt","r");
       fdi2 = $fopen("input_1trkproj_D3_3.txt","r");
       fdi3 = $fopen("input_1trkproj_D3_4.txt","r");
       fdi4 = $fopen("input_1trkproj_D4_2.txt","r");
       fdi5 = $fopen("input_1trkproj_D4_3.txt","r");
       fdi6 = $fopen("input_1trkproj_D4_4.txt","r");
       

      // USE THIS FOR RUNNING THE DISK PROJECTS (TODO: add 'official' disk project input files)
      // input_1trk_D5              --> single tracks without projections to neighboring sectors for D5 only project
      // input_1trk_D5D6_2/3/4      --> single tracks without projections to neighboring sectors for D5 in D5D6 project
      // input_1trk_D6_2/3/4        --> single tracks without projections to neighboring sectors for D6 in D5D6 project
      // input_1trkproj_D5_2/3/4    --> single tracks with projections to neighboring sectors for D5 in D5D6 project
      // input_1trkproj_D6_2/3/4    --> single tracks with projections to neighboring sectors for D6 in D5D6 project
      
      //fdi1 = $fopen("input_1trk_D5_2.txt","r");
      //fdi2 = $fopen("input_1trk_D5_3.txt","r");   
      //fdi3 = $fopen("input_1trk_D5_4.txt","r");  
      
       /*
       // 1trk D5D6 without projections
       fdi1 = $fopen("input_1trk_D5D6_2.txt","r");
       fdi2 = $fopen("input_1trk_D5D6_3.txt","r");   
       fdi3 = $fopen("input_1trk_D5D6_4.txt","r");            
       fdi4 = $fopen("input_1trk_D6_2.txt","r");
       fdi5 = $fopen("input_1trk_D6_3.txt","r");   
       fdi6 = $fopen("input_1trk_D6_4.txt","r");
       */
       
       /*
       // 1trk D5D6 with projections
       fdi1 = $fopen("input_1trkproj_D5_2.txt","r");
       fdi2 = $fopen("input_1trkproj_D5_3.txt","r");   
       fdi3 = $fopen("input_1trkproj_D5_4.txt","r");            
       fdi4 = $fopen("input_1trkproj_D6_2.txt","r");
       fdi5 = $fopen("input_1trkproj_D6_3.txt","r");   
       fdi6 = $fopen("input_1trkproj_D6_4.txt","r");        
       */
      
       /*
       // 2trk D5D6 with projections
       fdi1 = $fopen("input_2trkproj_D5_2.txt","r");
       fdi2 = $fopen("input_2trkproj_D5_3.txt","r");   
       fdi3 = $fopen("input_2trkproj_D5_4.txt","r");            
       fdi4 = $fopen("input_2trkproj_D6_2.txt","r");
       fdi5 = $fopen("input_2trkproj_D6_3.txt","r");   
       fdi6 = $fopen("input_2trkproj_D6_4.txt","r");          
       */
      
       /*
       // 5trk D5D6 with projections
       fdi1 = $fopen("input_5trkproj_D5_2.txt","r");
       fdi2 = $fopen("input_5trkproj_D5_3.txt","r");   
       fdi3 = $fopen("input_5trkproj_D5_4.txt","r");            
       fdi4 = $fopen("input_5trkproj_D6_2.txt","r");
       fdi5 = $fopen("input_5trkproj_D6_3.txt","r");   
       fdi6 = $fopen("input_5trkproj_D6_4.txt","r"); 
       */

       /*
       // 1trk D4D6
       fdi1 = $fopen("/home/mzientek/input_1trk_D4_2.txt","r");
       fdi2 = $fopen("/home/mzientek/input_1trk_D4_3.txt","r");   
       fdi3 = $fopen("/home/mzientek/input_1trk_D4_4.txt","r");            
       fdi4 = $fopen("/home/mzientek/input_1trk_D5_2.txt","r");
       fdi5 = $fopen("/home/mzientek/input_1trk_D5_3.txt","r");   
       fdi6 = $fopen("/home/mzientek/input_1trk_D5_4.txt","r");      
       fdi7 = $fopen("/home/mzientek/input_1trk_D6_2.txt","r");   
       fdi8 = $fopen("/home/mzientek/input_1trk_D6_3.txt","r");   
       fdi9 = $fopen("/home/mzientek/input_1trk_D6_4.txt","r");   
        */
        
      
      # 900
         
        while (!$feof(fdi1)) begin

           // --------------------------------------------------------------------------------
           // INPUTS FOR D3 PROJECT (or D5 project)
           // --------------------------------------------------------------------------------

           val1 = $fgets(str1, fdi1);
           dummy1 = $sscanf(str1, "%x %x %x %x %x %x", data_link1_0, data_link1_1, data_link2_0, data_link2_1, data_link3_0, data_link3_1);
           link1_reg1_minus = {data_link1_0[15:0],data_link1_1[19:18],14'h3fff}; link1_reg2_minus = {data_link1_1[17:0],14'h3ff};   
           link2_reg1_minus = {data_link2_0[15:0],data_link2_1[19:18],14'h3fff}; link2_reg2_minus = {data_link2_1[17:0],14'h3ff};   
           link3_reg1_minus = {data_link3_0[15:0],data_link3_1[19:18],14'h3fff}; link3_reg2_minus = {data_link3_1[17:0],14'h3ff};   

           val2 = $fgets(str2, fdi2);
           dummy2 = $sscanf(str2, "%x %x %x %x %x %x", data_link1_02, data_link1_12, data_link2_02, data_link2_12, data_link3_02, data_link3_12);
           link1_reg1_central = {data_link1_02[15:0],data_link1_12[19:18],14'h3fff}; link1_reg2_central = {data_link1_12[17:0],14'h3ff};   
           link2_reg1_central = {data_link2_02[15:0],data_link2_12[19:18],14'h3fff}; link2_reg2_central = {data_link2_12[17:0],14'h3ff};   
           link3_reg1_central = {data_link3_02[15:0],data_link3_12[19:18],14'h3fff}; link3_reg2_central = {data_link3_12[17:0],14'h3ff};   

           val3 = $fgets(str3, fdi3);
           dummy3 = $sscanf(str3, "%x %x %x %x %x %x", data_link1_03, data_link1_13, data_link2_03, data_link2_13, data_link3_03, data_link3_13);
           link1_reg1_plus = {data_link1_03[15:0],data_link1_13[19:18],14'h3fff}; link1_reg2_plus = {data_link1_13[17:0],14'h3ff};   
           link2_reg1_plus = {data_link2_03[15:0],data_link2_13[19:18],14'h3fff}; link2_reg2_plus = {data_link2_13[17:0],14'h3ff};   
           link3_reg1_plus = {data_link3_03[15:0],data_link3_13[19:18],14'h3fff}; link3_reg2_plus = {data_link3_13[17:0],14'h3ff};               
           
           // --------------------------------------------------------------------------------
           // ADDITIONAL INPUTS FOR D3D4 PROJECT (or D5D6 project)
           // --------------------------------------------------------------------------------
           
           val4 = $fgets(str4, fdi4);
           dummy4 = $sscanf(str4, "%x %x %x %x %x %x", data_link4_0, data_link4_1, data_link5_0, data_link5_1, data_link6_0, data_link6_1);
           link4_reg1_minus = {data_link4_0[15:0],data_link4_1[19:18],14'h3fff}; link4_reg2_minus = {data_link4_1[17:0],14'h3ff};   
           link5_reg1_minus = {data_link5_0[15:0],data_link5_1[19:18],14'h3fff}; link5_reg2_minus = {data_link5_1[17:0],14'h3ff};   
           link6_reg1_minus = {data_link6_0[15:0],data_link6_1[19:18],14'h3fff}; link6_reg2_minus = {data_link6_1[17:0],14'h3ff};   

           val5 = $fgets(str5, fdi5);
           dummy5 = $sscanf(str5, "%x %x %x %x %x %x", data_link4_02, data_link4_12, data_link5_02, data_link5_12, data_link6_02, data_link6_12);
           link4_reg1_central = {data_link4_02[15:0],data_link4_12[19:18],14'h3fff}; link4_reg2_central = {data_link4_12[17:0],14'h3ff};   
           link5_reg1_central = {data_link5_02[15:0],data_link5_12[19:18],14'h3fff}; link5_reg2_central = {data_link5_12[17:0],14'h3ff};   
           link6_reg1_central = {data_link6_02[15:0],data_link6_12[19:18],14'h3fff}; link6_reg2_central = {data_link6_12[17:0],14'h3ff};   

           val6 = $fgets(str6, fdi6);
           dummy6 = $sscanf(str6, "%x %x %x %x %x %x", data_link4_03, data_link4_13, data_link5_03, data_link5_13, data_link6_03, data_link6_13);
           link4_reg1_plus = {data_link4_03[15:0],data_link4_13[19:18],14'h3fff}; link4_reg2_plus = {data_link4_13[17:0],14'h3ff};   
           link5_reg1_plus = {data_link5_03[15:0],data_link5_13[19:18],14'h3fff}; link5_reg2_plus = {data_link5_13[17:0],14'h3ff};   
           link6_reg1_plus = {data_link6_03[15:0],data_link6_13[19:18],14'h3fff}; link6_reg2_plus = {data_link6_13[17:0],14'h3ff};               

           // --------------------------------------------------------------------------------
           // ADDITIONAL INPUTS FOR D4D6 PROJECT (3 DTC regions)
           // --------------------------------------------------------------------------------
           /*
           val7 = $fgets(str7, fdi7);
           dummy7 = $sscanf(str7, "%x %x %x %x %x %x", data_link7_0, data_link7_1, data_link8_0, data_link8_1, data_link9_0, data_link9_1);
           link7_reg1_minus = {18'b0,14'h3fff}; link7_reg2_minus = {18'b0,14'h3ff};
           link8_reg1_minus = {18'b0,14'h3fff}; link8_reg2_minus = {18'b0,14'h3ff};
           link9_reg1_minus = {18'b0,14'h3fff}; link9_reg2_minus = {18'b0,14'h3ff};
           //link7_reg1_minus = {data_link7_0[15:0],data_link7_1[19:18],14'h3fff}; link7_reg2_minus = {data_link7_1[17:0],14'h3ff};   
           //link8_reg1_minus = {data_link8_0[15:0],data_link8_1[19:18],14'h3fff}; link8_reg2_minus = {data_link8_1[17:0],14'h3ff};   
           //link9_reg1_minus = {data_link9_0[15:0],data_link9_1[19:18],14'h3fff}; link9_reg2_minus = {data_link9_1[17:0],14'h3ff};   

           val8 = $fgets(str8, fdi8);
           dummy8 = $sscanf(str8, "%x %x %x %x %x %x", data_link7_02, data_link7_12, data_link8_02, data_link8_12, data_link9_02, data_link9_12);   
           link7_reg1_central = {data_link7_02[15:0],data_link7_12[19:18],14'h3fff}; link7_reg2_central = {data_link7_12[17:0],14'h3ff};   
           link8_reg1_central = {data_link8_02[15:0],data_link8_12[19:18],14'h3fff}; link8_reg2_central = {data_link8_12[17:0],14'h3ff};   
           link9_reg1_central = {data_link9_02[15:0],data_link9_12[19:18],14'h3fff}; link9_reg2_central = {data_link9_12[17:0],14'h3ff};   

           val9 = $fgets(str9, fdi9);
           dummy9 = $sscanf(str9, "%x %x %x %x %x %x", data_link7_03, data_link7_13, data_link8_03, data_link8_13, data_link9_03, data_link9_13);
           link7_reg1_plus = {18'b0,14'h3fff}; link7_reg2_plus = {18'b0,14'h3ff};
           link8_reg1_plus = {18'b0,14'h3fff}; link8_reg2_plus = {18'b0,14'h3ff};
           link9_reg1_plus = {18'b0,14'h3fff}; link9_reg2_plus = {18'b0,14'h3ff};
           //link7_reg1_plus = {data_link7_03[15:0],data_link7_13[19:18],14'h3fff}; link7_reg2_plus = {data_link7_13[17:0],14'h3ff};   
           //link8_reg1_plus = {data_link8_03[15:0],data_link8_13[19:18],14'h3fff}; link8_reg2_plus = {data_link8_13[17:0],14'h3ff};   
           //link9_reg1_plus = {data_link9_03[15:0],data_link9_13[19:18],14'h3fff}; link9_reg2_plus = {data_link9_13[17:0],14'h3ff};     
           */
           #5;
        end
      #2 link1_reg1_central = 32'hdeadbeef;
         
   end
   
   
endmodule
