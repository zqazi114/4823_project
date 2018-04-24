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

parameter WORDSIZE = 16;
parameter ADDRSIZE = 6;

input clk, read_addr, write_addr, rd_en, wr_en, cs, data_in;
output data_out;

wire clk;
wire [ADDRSIZE-1:0] read_addr, write_addr;
wire rd_en, wr_en, cs;
wire [WORDSIZE-1:0] data_in;
wire [WORDSIZE-1:0] data_out;

reg [WORDSIZE-1:0] memory [ADDRSIZE-1:0];
reg [WORDSIZE-1:0] data_out_z;

integer i;

assign data_out = cs ? data_out_z : {WORDSIZE{1'bz}};

initial
begin
	data_out_z <= 0;
	for(i = 0; i < 2**ADDRSIZE; i = i+1)
		memory[i] <= {WORDSIZE{1'b0}};
end

always @(posedge clk)
begin : READ
	if(rd_en)
		data_out_z <= memory[read_addr];
end

always @(negedge clk)
begin : WRITE
	if(wr_en)
		memory[write_addr] <= data_in;
end

endmodule
