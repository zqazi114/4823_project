// -------------------- define timescale -----------------------
`timescale 1ns/1ps

module mux_control_tb();

// -------------------- define parameters -----------------------
parameter NUMSTAGES = 8;
parameter NUMSAMPLES = 256;
parameter WORDSIZE = 16;
parameter WL=16, IWL=5, FWL=10;

// -------------------- create inputs and oututs -----------------------
reg ld_data;
reg [NUMSTAGES-3:0] counter_r;
reg [3:0] stage_num_r;
wire m0_s, m2_s, m3_s;
wire [1:0] m1_s;

// -------------------- testbench variables -----------------------
reg clk;

// -------------------- module being tested -----------------------
mux_control #(.NUMSTAGES(NUMSTAGES)) m0(
	ld_data,
	counter_r,
	stage_num_r,
	m0_s, m1_s, m2_s, m3_s	
);

// -------------------- initialize -----------------------
initial
begin
	ld_data <= 0;
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
	ld_data <= #1 1'b1;
	if(stage_num_r < 4'b1000)
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
