// -------------------- define timescale -----------------------
`timescale 1ns/1ps

module pe_tb();

// -------------------- define parameters -----------------------
parameter WORDSIZE = 16;
parameter WL=16, IWL=5, FWL=10;

// -------------------- create inputs and oututs -----------------------
reg [WORDSIZE-1:0] in0_r, in1_r, in2_r, in3_r;
reg [WORDSIZE-1:0] twiddle_r;
wire [WORDSIZE-1:0] out0, out1, out2, out3;

// -------------------- testbench variables -----------------------
reg clk;
reg [WORDSIZE-1:0] in0_arr [0:9];
reg [WORDSIZE-1:0] in1_arr [0:9];
reg [WORDSIZE-1:0] in2_arr [0:9];
reg [WORDSIZE-1:0] in3_arr [0:9];
reg [WORDSIZE-1:0] twiddle_arr [0:9];

// -------------------- module being tested -----------------------
pe #(.WORDSIZE(WORDSIZE), .WL(WL), .IWL(IWL), .FWL(FWL)) pe0(
	in0_r, in1_r, in2_r, in3_r,
	twiddle_r,
	out0, out1, out2, out3
);

integer i;

// -------------------- initialize -----------------------
initial
begin
	clk <= 1'b0;
	in0_r <= #0.1 {WORDSIZE{1'b0}};
	in1_r <= #0.1 {WORDSIZE{1'b0}};
	in2_r <= #0.1 {WORDSIZE{1'b0}};
	in3_r <= #0.1 {WORDSIZE{1'b0}};
	twiddle_r <= #0.1 {WORDSIZE{1'b0}};

	i = 0;

	in0_arr[0] = 16'h0001; in0_arr[1] = 16'h0010; in0_arr[2] = 16'h0011; in0_arr[3] = 16'h0100; 
	in0_arr[4] = 16'h0101; in0_arr[5] = 16'h0110; in0_arr[6] = 16'h0111; in0_arr[7] = 16'h1000; 
	in0_arr[8] = 16'h1001; in0_arr[9] = 16'h1010; 

	in1_arr[0] = 16'h0001; in1_arr[1] = 16'h0010; in1_arr[2] = 16'h0011; in1_arr[3] = 16'h0100; 
	in1_arr[4] = 16'h0101; in1_arr[5] = 16'h0110; in1_arr[6] = 16'h0111; in1_arr[7] = 16'h1000; 
	in1_arr[8] = 16'h1001; in1_arr[9] = 16'h1010; 

	in2_arr[0] = 16'h0001; in2_arr[1] = 16'h0010; in2_arr[2] = 16'h0011; in2_arr[3] = 16'h0100; 
	in2_arr[4] = 16'h0101; in2_arr[5] = 16'h0110; in2_arr[6] = 16'h0111; in2_arr[7] = 16'h1000; 
	in2_arr[8] = 16'h1001; in2_arr[9] = 16'h1010; 

	in3_arr[0] = 16'h0001; in3_arr[1] = 16'h0010; in3_arr[2] = 16'h0011; in3_arr[3] = 16'h0100; 
	in3_arr[4] = 16'h0101; in3_arr[5] = 16'h0110; in3_arr[6] = 16'h0111; in3_arr[7] = 16'h1000; 
	in3_arr[8] = 16'h1001; in3_arr[9] = 16'h1010; 
	
	twiddle_arr[0] = 16'h0001; twiddle_arr[1] = 16'h0010; twiddle_arr[2] = 16'h0011; twiddle_arr[3] = 16'h0100; 
	twiddle_arr[4] = 16'h0101; twiddle_arr[5] = 16'h0110; twiddle_arr[6] = 16'h0111; twiddle_arr[7] = 16'h1000; 
	twiddle_arr[8] = 16'h1001; twiddle_arr[9] = 16'h1010; 

end

// -------------------- clock generation -----------------------
always @(*)
begin
	clk <= #0.05~clk;
end

// -------------------- testing -----------------------
always @(posedge clk)
begin
	if(i < 10)
	begin
		in0_r <= in0_arr[i];
		in1_r <= in1_arr[i];
		in2_r <= in2_arr[i];
		in3_r <= in3_arr[i];
		twiddle_r <= twiddle_arr[i];
		i = i + 1;
	end
end

endmodule
