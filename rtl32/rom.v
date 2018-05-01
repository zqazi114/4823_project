module rom(
	clk,
	cs,
	addr,
	data
);

parameter WORDSIZE = 16; 	// word size 16-bits
parameter ADDRSIZE = 5;		// number of bits in address
parameter NUMADDR = 32;		// number of addresses

input clk, cs, addr;
output data;

wire clk;
wire cs;
wire [ADDRSIZE-1:0] addr;
wire [WORDSIZE-1:0] data;

reg [WORDSIZE-1:0] memory [0:NUMADDR-1];
reg [WORDSIZE-1:0] data_r;

integer i;

assign data = cs ? data_r : {WORDSIZE{1'bz}};

initial
begin
	data_r <= 0;
	memory[0]  <= 16'h0000; memory[1]  <= 16'h0000; memory[2]  <= 16'h0000; memory[3]  <= 16'h0000;
	memory[4]  <= 16'h0000; memory[5]  <= 16'h0000; memory[6]  <= 16'h0000; memory[7]  <= 16'h0000;
	memory[8]  <= 16'h0000; memory[9]  <= 16'h0000; memory[10] <= 16'h0000; memory[11] <= 16'h0000;
	memory[12] <= 16'h0000; memory[13] <= 16'h0000; memory[14] <= 16'h0000; memory[15] <= 16'h0000;
	memory[16] <= 16'h0000; memory[17] <= 16'h0000; memory[18] <= 16'h0000; memory[19] <= 16'h0000;
	memory[20] <= 16'h0000; memory[21] <= 16'h0000; memory[22] <= 16'h0000; memory[23] <= 16'h0000;
	memory[24] <= 16'h0000; memory[25] <= 16'h0000; memory[26] <= 16'h0000; memory[27] <= 16'h0000;
	memory[28] <= 16'h0000; memory[29] <= 16'h0000; memory[30] <= 16'h0000; memory[31] <= 16'h0000;
end

always @(posedge clk)
begin : READ
	data_r <= memory[addr];
end

endmodule
