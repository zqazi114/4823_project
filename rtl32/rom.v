module rom(
	clk,
	cs,
	addr,
	data1,
	data2
);

integer               tw_file     ; // var to see if file exists
integer               scan_inputs     ; // captured text handler

//TXT
//reg [127:0] captured_outputs; ///Actual text obtained from outputs.txt lines
reg [127:0] twiddle;  ///Actual text obtained from inputs.txt lines


parameter WORDSIZE = 16; 	// word size 16-bits
parameter ADDRSIZE = 8;		// number of bits in address
parameter NUMADDR = 256;	// number of addresses

input clk, cs, addr;
output data1, data2;

wire clk;
wire cs;
wire [ADDRSIZE-1:0] addr;
wire [WORDSIZE-1:0] data1, data2;

reg [WORDSIZE-1:0] memory [0:NUMADDR-1];
reg [WORDSIZE-1:0] data1_r, data2_r;

integer i;

assign data1 = cs ? data1_r : {WORDSIZE{1'bz}};
assign data2 = cs ? data2_r : {WORDSIZE{1'bz}};


initial
begin
	data1_r <= 0;
	data2_r <= 0;

   $readmemh("twiddle256.dat", memory);

	
//	memory[0]  <= 16'h0000; memory[1]  <= 16'h0000; memory[2]  <= 16'h0000; memory[3]  <= 16'h0000;
//	memory[4]  <= 16'h0000; memory[5]  <= 16'h0000; memory[6]  <= 16'h0000; memory[7]  <= 16'h0000;
//	memory[8]  <= 16'h0000; memory[9]  <= 16'h0000; memory[10] <= 16'h0000; memory[11] <= 16'h0000;
//	memory[12] <= 16'h0000; memory[13] <= 16'h0000; memory[14] <= 16'h0000; memory[15] <= 16'h0000;
//	memory[16] <= 16'h0000; memory[17] <= 16'h0000; memory[18] <= 16'h0000; memory[19] <= 16'h0000;
//	memory[20] <= 16'h0000; memory[21] <= 16'h0000; memory[22] <= 16'h0000; memory[23] <= 16'h0000;
//	memory[24] <= 16'h0000; memory[25] <= 16'h0000; memory[26] <= 16'h0000; memory[27] <= 16'h0000;
//	memory[28] <= 16'h0000; memory[29] <= 16'h0000; memory[30] <= 16'h0000; memory[31] <= 16'h0000;
//	memory[32] <= 16'h0000; memory[33] <= 16'h0000; memory[34] <= 16'h0000; memory[35] <= 16'h0000;
//	memory[36] <= 16'h0000; memory[37] <= 16'h0000; memory[38] <= 16'h0000; memory[39] <= 16'h0000;
//	memory[40] <= 16'h0000; memory[41] <= 16'h0000; memory[42] <= 16'h0000; memory[43] <= 16'h0000;
//	memory[44] <= 16'h0000; memory[45] <= 16'h0000; memory[46] <= 16'h0000; memory[47] <= 16'h0000;
//	memory[48] <= 16'h0000; memory[49] <= 16'h0000; memory[50] <= 16'h0000; memory[51] <= 16'h0000;
//	memory[52] <= 16'h0000; memory[53] <= 16'h0000; memory[54] <= 16'h0000; memory[55] <= 16'h0000;
//	memory[56] <= 16'h0000; memory[57] <= 16'h0000; memory[58] <= 16'h0000; memory[59] <= 16'h0000;
//	memory[60] <= 16'h0000; memory[61] <= 16'h0000; memory[62] <= 16'h0000; memory[63] <= 16'h0000;
end

always @(posedge clk)
begin : READ
	data1_r <= memory[addr];
	data2_r <= memory[addr+NUMADDR/2];
end

endmodule
