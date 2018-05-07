module twiddle(
	clk,
	ld_twiddle,
	counter,
	stage_num,
	twiddle_r,
	twiddle_i,
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
output twiddle_r, twiddle_i;


// -------------------- define port types ------------------------
wire clk;
wire ld_twiddle;
wire [NUMSTAGES-3:0] counter;
wire [2:0] stage_num;
wire [WORDSIZE-1:0] twiddle_r, twiddle_i;


// -------------------- define local variables ------------------------
reg cs_r;
reg [ADDRSIZE-1:0] addr_r;


// -------------------- code beings here ------------------------


// -------------------- ROM module ------------------------
rom #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMADDR)) rom0(
	clk,
	cs_r,
	addr_r,
	twiddle_r,
	twiddle_i
);

initial
begin
	cs_r <= 0;
	addr_r <= 0;
end

always @(posedge clk)
begin
	cs_r <= 1'b1;
	case(stage_num)
	STAGE0: addr_r = counter;
    STAGE1: 
        if(counter[2] == 0)
            addr_r = counter[1:0] << 1;
        else
            addr_r = counter[1:0] << 2;
    STAGE2:
        if(counter[2:1] == 2'b0)
            addr_r = counter[0] << 2;
        else
            addr_r = counter[0] << 3;
    default:
        addr_r = 0;
    endcase

end

endmodule
