// -------------------- define timescale -----------------------
`timescale 1ns/1ps

module fft_stage_control_tb();

// -------------------- define parameters -----------------------
parameter NUMSTAGES = 5;
parameter NUMSAMPLES = 32;
parameter WORDSIZE = 16;
parameter WL=16, IWL=5, FWL=10;

// -------------------- create inputs and oututs -----------------------
reg en_r;
reg [2:0] stage_num_r;
wire m0_s, m2_s, m3_s;
wire [1:0] m1_s;
wire [NUMSTAGES-3:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
wire [NUMSTAGES-3:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
wire stage_done;

// -------------------- testbench variables -----------------------
reg clk;

// -------------------- module being tested -----------------------
fft_stage_control #(.NUMSTAGES(NUMSTAGES)) fsc0(
	clk,
	en_r,
	stage_num_r,
	m0_s, m1_s, m2_s, m3_s,
	rd_addr0, rd_addr1, rd_addr2, rd_addr3,
	wr_addr0, wr_addr1, wr_addr2, wr_addr3,
	stage_done
);

// -------------------- initialize -----------------------
initial
begin
	clk <= 0;
	stage_num_r <= 0;
	en_r <= 1;
end

// -------------------- clock generation -----------------------
always @(*)
begin
	clk <= #0.05~clk;
end

// -------------------- testing -----------------------
always @(posedge clk)
begin
	if(stage_num_r <= 3'b101)
	begin
		if(stage_done && en_r) begin 
			stage_num_r = stage_num_r + 1;
			en_r <= 1'b0;
		end else if(~en_r)
			en_r <= 1'b1;
	end else 
		en_r <= 1'b0;
end

endmodule
