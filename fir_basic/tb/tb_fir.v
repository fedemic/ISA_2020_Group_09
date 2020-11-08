//`timescale 1ns

module tb_fir ();

   wire CLK_tb;
   wire RST_n_tb;
   wire [7:0] DIN_tb;
   wire VIN_tb;
   wire [7:0] B0_tb;
   wire [7:0] B1_tb;
   wire [7:0] B2_tb;
   wire [7:0] B3_tb;
   wire [7:0] B4_tb;
   wire [7:0] B5_tb;
   wire [7:0] B6_tb;
   wire [7:0] B7_tb;
   wire [7:0] B8_tb;
   wire [7:0] DOUT_tb;
   wire VOUT_tb;
   wire END_SIM_tb;

   Clk_rst_gen CG(.END_SIM(END_SIM_tb),
  	              .CLK(CLK_tb),
	                .RST_n(RST_n_tb));

   Read_data RD(.CLK(CLK_tb),
	              .RST_n(RST_n_tb),
		            .VOUT(VIN_tb),
		            .DOUT(DIN_tb),
		            .B0(B0_tb),
		            .B1(B1_tb),
		            .B2(B2_tb),
		            .B3(B3_tb),
		            .B4(B4_tb),
		            .B5(B5_tb),
		            .B6(B6_tb),
		            .B7(B7_tb),
		            .B8(B8_tb),
		            .END_SIM(END_SIM_tb));

   Fir DUT(.CLK(CLK_tb),
	         .RST_N(RST_n_tb),
	         .DIN(DIN_tb),
           .VIN(VIN_tb),
	         .B0(B0_tb),
		       .B1(B1_tb),
		       .B2(B2_tb),
		       .B3(B3_tb),
		       .B4(B4_tb),
		       .B5(B5_tb),
		       .B6(B6_tb),
		       .B7(B7_tb),
		       .B8(B8_tb),
           .DOUT(DOUT_tb),
           .VOUT(VOUT_tb));

   Write_results WR(.CLK(CLK_tb),
		                .RST_n(RST_n_tb),
		                .VIN(VOUT_tb),
		                .DIN(DOUT_tb));

   Error_check EC(.CLK(CLK_tb),
                  .RST_n(RST_n_tb),
                  .FIR_OUT(DOUT_tb),
                  .VOUT(VOUT_tb));

endmodule
