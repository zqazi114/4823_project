/*
 *	This is the module for the fft_stage control signals. 
 *
 */

module fft_stage_control(
	clk, 		// clock
	en, 		// enable signal (active high)
	stage_num,	// stage number
	m0_s,		// mux 0 select
	m1_s,		// mux 1 select
	m2_s,		// mux 2 select
	m3_s,		// mux 3 select
	rd_addr0,	// 0: read address
	rd_addr1,	// 1: read address
	rd_addr2,	// 2: read address
	rd_addr3,	// 3: read address
	wr_addr0,	// 0: write address
	wr_addr1,	// 1: write address
	wr_addr2,	// 2: write address
	wr_addr3,	// 3: write address
	stage_done	// stage completed
);


//---------------- parameters ---------------------
parameter NUMSTAGES = 5;


//---------------- define inputs and outputs ---------------------
input clk, en, stage_num;
output m0_s, m1_s, m2_s, m3_s;
output rd_addr0, rd_addr1, rd_addr2, rd_addr3;
output wr_addr0, wr_addr1, wr_addr2, wr_addr3;
output stage_done;


//---------------- define port types ---------------------
wire clk;
wire en;
wire [2:0] stage_num;
wire m0_s;
wire [1:0] m1_s;
wire m2_s;
wire m3_s;
wire [NUMSTAGES-3:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
wire [NUMSTAGES-3:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
reg stage_done;


//---------------- define local variables ---------------------
reg [NUMSTAGES-3:0] counter_r;
reg m0_s_r;
reg [1:0] m1_s_r;
reg m2_s_r;
reg m3_s_r;
reg [NUMSTAGES-3:0] rd_addr0_r, rd_addr1_r, rd_addr2_r, rd_addr3_r;
reg [NUMSTAGES-3:0] wr_addr0_r, wr_addr1_r, wr_addr2_r, wr_addr3_r;


//---------------- tristate buffer ---------------------
assign m0_s = en ? m0_s_r : 1'bz;
assign m1_s = en ? m1_s_r : 2'bzz;
assign m2_s = en ? m2_s_r : 1'bz;
assign m3_s = en ? m3_s_r : 1'bz;

assign rd_addr0 = en ? rd_addr0_r : {NUMSTAGES-2{1'bz}};
assign rd_addr1 = en ? rd_addr1_r : {NUMSTAGES-2{1'bz}};
assign rd_addr2 = en ? rd_addr2_r : {NUMSTAGES-2{1'bz}};
assign rd_addr3 = en ? rd_addr3_r : {NUMSTAGES-2{1'bz}};
assign wr_addr0 = en ? wr_addr0_r : {NUMSTAGES-2{1'bz}};
assign wr_addr1 = en ? wr_addr1_r : {NUMSTAGES-2{1'bz}};
assign wr_addr2 = en ? wr_addr2_r : {NUMSTAGES-2{1'bz}};
assign wr_addr3 = en ? wr_addr3_r : {NUMSTAGES-2{1'bz}};


//---------------- address generator ---------------------
address_control #(.NUMSTAGES(NUMSTAGES)) acontrol0(
	counter_r, stage_num, 
	rd_addr0_r, rd_addr1_r, rd_addr2_r, rd_addr3_r,	
	wr_addr0_r, wr_addr1_r, wr_addr2_r, wr_addr3_r
);


//---------------- MUX control signal generator ---------------------
mux_control #(.NUMSTAGES(NUMSTAGES)) mux_ctrl(
	counter_r, stage_num, m0_s_r, m1_s_r, m2_s_r, m3_s_r); 


//---------------- code begins here ---------------------
initial
begin
	stage_done 	<= 0;
	counter_r 	<= 0;
end

always @(posedge clk)
begin
	if(en) begin
		counter_r <= counter_r + 1;
		if(counter_r == 3'b111)
			stage_done <= ~stage_done;
	end
	else 
		counter_r <= {NUMSTAGES-3{1'b0}};
end

endmodule
