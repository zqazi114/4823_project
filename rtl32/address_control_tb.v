// -------------------- define timescale -----------------------
`timescale 1ns/1ps

module address_control_tb();

// -------------------- define parameters -----------------------
parameter NUMSTAGES = 5;
parameter NUMSAMPLES = 32;
parameter WORDSIZE = 16;
parameter WL=16, IWL=5, FWL=10;

// -------------------- create inputs and oututs -----------------------
reg [NUMSTAGES-3:0] counter_r;
reg [2:0] stage_num_r;
wire [NUMSTAGES-3:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
wire [NUMSTAGES-3:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;

// -------------------- testbench variables -----------------------
reg clk;

// -------------------- module being tested -----------------------
address_control #(.NUMSTAGES(NUMSTAGES)) a0(
	counter_r,
	stage_num_r,
	rd_addr0, rd_addr1, rd_addr2, rd_addr3,
	wr_addr0, wr_addr1, wr_addr2, wr_addr3
);

// -------------------- initialize -----------------------
initial
begin
	clk <= 0;
	counter_r <= 0;
	stage_num_r <= 0;
end

// -------------------- clock generation -----------------------
always @(*)
begin
	clk <= #0.05~clk;
end

// -------------------- testing -----------------------
always @(posedge clk)
begin
	if(stage_num_r < 3'b101)
	begin
		if(counter_r == {NUMSTAGES-2{1'b1}})
		begin
			stage_num_r = stage_num_r + 1;
			counter_r <= 0;
		end else 
			counter_r <= counter_r + 1;
	end
end

endmodule
