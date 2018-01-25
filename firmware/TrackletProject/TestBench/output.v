`timescale 1 ns / 1 ps 

//---------------------------------------------------
// Write outputs to text file
//---------------------------------------------------

module output_sim #(
parameter NUM_OUTPUT  = 1,
parameter WHICH_OUTPUT = 1,
parameter TYPE_OUTPUT = "AllStubs",
parameter USER = "/home/mzientek/firmware/TrackletProject/TestBench/OutFiles/"
)(
    input clk,
    input reset,
    input BC0
);

    //---------------------------------------------------
    // Outputs
    //---------------------------------------------------
    
    // file handlers
    integer fdo1;
    integer num = NUM_OUTPUT-1;

    string stringname;
    initial begin
        $sformat(stringname,"Output_Type%0d_%0d.dat",WHICH_OUTPUT,num);
        $display("Name = %s",stringname); 
        fdo1 = $fopen({USER,stringname},"w");
    end
              
    genvar i;
    generate
        for (i = NUM_OUTPUT-1; i < NUM_OUTPUT; i = i + 1) begin // hack to allow for variable i in finding memory
            // -------------------------- TYPE1 outputs -------------------------------------
            if (WHICH_OUTPUT==1) begin
                if (TYPE_OUTPUT=="CustomOut") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.CustomOut.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.CustomOut.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.CustomOut.mem.data_in_dly
                        );
                    end
                end
                if (TYPE_OUTPUT=="AllStubs") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.AS.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.AS.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.AS.mem.data_in_dly
                        );
                    end
                end
                if (TYPE_OUTPUT=="StubsByLayer") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.SL.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.SL.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.SL.mem.data_in_dly
                        );
                    end
                end                
                if (TYPE_OUTPUT=="VMStubs") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.VS.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.VS.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.VS.mem.data_in_dly
                        );
                    end
                end  
                if (TYPE_OUTPUT=="StubPairs") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.SP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.SP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.SP.mem.data_in_dly
                        );
                    end
                end                 
                if (TYPE_OUTPUT=="TrackletParameters") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.TR.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.TR.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.TR.mem.data_in_dly
                        );
                    end
                end 
                if (TYPE_OUTPUT=="TrackletProjections") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.TP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.TP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.TP.mem.data_in_dly
                        );
                    end
                end 
                if (TYPE_OUTPUT=="VMProjections") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.VP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.VP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.VP.mem.data_in_dly
                        );
                    end
                end   
                if (TYPE_OUTPUT=="AllProj") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.AP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.AP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.AP.mem.data_in_dly
                        );
                    end
                end  
                if (TYPE_OUTPUT=="CandidateMatch") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.CM.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.CM.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.CM.mem.data_in_dly
                        );
                    end
                end  
                if (TYPE_OUTPUT=="FullMatch") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.FM.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.FM.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.FM.mem.data_in_dly
                        );
                    end
                end                                                                                
                if (TYPE_OUTPUT=="TrackFit") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.FT.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.FT.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.FT.mem.data_in_dly
                        );
                    end
                end    
                if (TYPE_OUTPUT=="CleanTrack") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem1[i].memout.CT.mem.wr_en,
                        top_process.tracklet_process.gen_outmem1[i].memout.CT.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem1[i].memout.CT.mem.data_in_dly
                        );
                    end
                end              
            end
            
            // -------------------------- TYPE2 outputs -------------------------------------
            if (WHICH_OUTPUT==2) begin
                if (TYPE_OUTPUT=="CustomOut") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.CustomOut.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.CustomOut.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.CustomOut.mem.data_in_dly
                        );
                    end
                end
                if (TYPE_OUTPUT=="AllStubs") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.AS.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.AS.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.AS.mem.data_in_dly
                        );
                    end
                end
                if (TYPE_OUTPUT=="StubsByLayer") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.SL.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.SL.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.SL.mem.data_in_dly
                        );
                    end
                end                
                if (TYPE_OUTPUT=="VMStubs") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.VS.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.VS.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.VS.mem.data_in_dly
                        );
                    end
                end  
                if (TYPE_OUTPUT=="StubPairs") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.SP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.SP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.SP.mem.data_in_dly
                        );
                    end
                end                 
                if (TYPE_OUTPUT=="TrackletParameters") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.TR.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.TR.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.TR.mem.data_in_dly
                        );
                    end
                end 
                if (TYPE_OUTPUT=="TrackletProjections") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.TP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.TP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.TP.mem.data_in_dly
                        );
                    end
                end 
                if (TYPE_OUTPUT=="VMProjections") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.VP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.VP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.VP.mem.data_in_dly
                        );
                    end
                end   
                if (TYPE_OUTPUT=="AllProj") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.AP.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.AP.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.AP.mem.data_in_dly
                        );
                    end
                end  
                if (TYPE_OUTPUT=="CandidateMatch") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.CM.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.CM.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.CM.mem.data_in_dly
                        );
                    end
                end  
                if (TYPE_OUTPUT=="FullMatch") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.FM.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.FM.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.FM.mem.data_in_dly
                        );
                    end
                end                                                                                
                if (TYPE_OUTPUT=="TrackFit") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.FT.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.FT.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.FT.mem.data_in_dly
                        );
                    end
                end    
                if (TYPE_OUTPUT=="CleanTrack") begin
                    always @(posedge clk) begin
                        $fwrite(fdo1, "%x %x %x\n",
                        top_process.tracklet_process.gen_outmem2[i].memout.CT.mem.wr_en,
                        top_process.tracklet_process.gen_outmem2[i].memout.CT.mem.BX_pipe,
                        top_process.tracklet_process.gen_outmem2[i].memout.CT.mem.data_in_dly
                        );
                    end
                end  
            end
        end
    endgenerate

endmodule