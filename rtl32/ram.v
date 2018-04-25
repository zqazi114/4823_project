module ram(
	clk,
	read_addr,
	write_addr,
	rd_en,
	wr_en,
	cs,
	data_in,
	data_out
);

parameter WORDSIZE = 16; 	// word size 16-bits
parameter ADDRSIZE = 5;		// number of bits in address
parameter NUMADDR = 8;	// number of addresses

input clk, read_addr, write_addr, rd_en, wr_en, cs, data_in;
output data_out;

wire clk;
wire [ADDRSIZE-1:0] read_addr, write_addr;
wire rd_en, wr_en, cs;
wire [WORDSIZE-1:0] data_in;
wire [WORDSIZE-1:0] data_out;

reg [WORDSIZE-1:0] memory [0:NUMADDR-1];
reg [WORDSIZE-1:0] data_out_r;

integer i;

assign data_out = cs ? data_out_r : {WORDSIZE{1'bz}};

initial
begin
	data_out_r <= 0;
	for(i = 0; i < NUMADDR; i = i+1)
		memory[i] <= i;
end

always @(posedge clk)
begin : READ
	if(rd_en)
		data_out_r <= memory[read_addr];
end

always @(negedge clk)
begin : WRITE
	if(wr_en)
		memory[write_addr] <= data_in;
end

endmodule
