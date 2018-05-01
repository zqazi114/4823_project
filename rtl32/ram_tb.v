// -------------------- define timescale -----------------------
`timescale 1ns/1ps

module ram_tb();

// -------------------- define parameters -----------------------
parameter NUMSTAGES = 5;
parameter NUMSAMPLES = 32;
parameter WORDSIZE = 16;
parameter WL=16, IWL=5, FWL=10;

// -------------------- create inputs and oututs -----------------------
reg [NUMSTAGES-1:0] read_addr_r, write_addr_r;
reg rd_en_r, wr_en_r, cs_r;
reg [WORDSIZE-1:0] data_in_r;
wire [WORDSIZE-1:0] data_out;

// -------------------- testbench variables -----------------------
reg clk;

integer i;

// -------------------- module being tested -----------------------
ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(NUMSTAGES), .NUMADDR(NUMSAMPLES/4)) ram0(
	clk,
	read_addr_r, write_addr_r,
	rd_en_r, wr_en_r, cs_r,
	data_in_r,
	data_out
);

// -------------------- initialize -----------------------
initial
begin
	clk <= 0;
	read_addr_r <= 0;
	write_addr_r <= 0;
	rd_en_r <= 0;
	wr_en_r <= 1;
	cs_r <= 1;
	data_in_r <= {WORDSIZE{1'b1}};
	i = 0;
end

// -------------------- clock generation -----------------------
always @(*)
begin
	clk <= #0.05~clk;
end

// -------------------- testing -----------------------
always @(posedge clk)
begin
	if(i < NUMSAMPLES/4)
	begin
		read_addr_r <= read_addr_r + 1;
		write_addr_r <= write_addr_r + 1;
		data_in_r <= data_in_r - 1;
		i = i + 1;
	end else begin
		i = 0;
		read_addr_r <= 0;
		write_addr_r <= 0;
		rd_en_r <= 1'b1;
		wr_en_r <= 1'b0;
	end
end

endmodule
