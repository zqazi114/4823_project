module twiddle(
	clk,
	ld_twiddle,
	counter,
	stage_num,
	twiddle
);


// -------------------- parameters ------------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 5;
parameter NUMADDR = 32;
parameter NUMSTAGES = 5;


// -------------------- states ------------------------
parameter STAGE0 = 3'b000, STAGE1 = 3'b001, STAGE2 = 3'b010, STAGE3 = 3'b011, STAGE4 = 3'b100;


// -------------------- define inputs and outputs ------------------------
input clk, ld_twiddle, counter, stage_num;
output twiddle;


// -------------------- define port types ------------------------
wire clk;
wire ld_twiddle;
wire [NUMSTAGES-3:0] counter;
wire [2:0] stage_num;
wire [WORDSIZE-1:0] twiddle;


// -------------------- define local variables ------------------------
reg [WORDSIZE-1:0] twiddle_r;
reg cs_r;
reg [ADDRSIZE-1:0] addr_r;


// -------------------- code beings here ------------------------
assign twiddle = twiddle_r;


// -------------------- ROM module ------------------------
rom #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMADDR)) rom0(
	clk,
	cs_r,
	addr_r,
	twiddle
);

initial
begin
	cs_r <= 0;
	addr_r <= 0;
end

always @(posedge clk)
begin
	cs_r <= 1'b0;
	addr_r <= {ADDRSIZE{1'bz}};
end

endmodule
