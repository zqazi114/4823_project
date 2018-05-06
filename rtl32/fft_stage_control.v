/*
 *	This is the module for the fft_stage control signals. 
 *
 */

module fft_stage_control(
	clk, 		// clock
	ld_data,	// data initialization signal
	en, 		// enable signal (active high)
	stage_num,	// stage number
	m0_s,		// mux 0 select
	m1_s,		// mux 1 select
	m2_s,		// mux 2 select
	m3_s,		// mux 3 select
	r_addr_0_1,	// 0,1: read address
	w_addr_0_1,	// 0,1: write address
	r_addr_2_3,	// 2,3: read address
	w_addr_2_3,	// 2,3: write address
	stage_done	// stage completed
);


//---------------- parameters ---------------------
parameter NUMSTAGES = 5;


//---------------- define inputs and outputs ---------------------
input clk, ld_data, en, stage_num;
output m0_s, m1_s, m2_s, m3_s;
output r_addr_0_1, w_addr_0_1;
output r_addr_2_3, w_addr_2_3;
output stage_done;


//---------------- define port types ---------------------
wire clk;
wire ld_data;
wire en;
wire [2:0] stage_num;
wire m0_s;
wire [1:0] m1_s;
wire m2_s;
wire m3_s;
wire [NUMSTAGES-3:0] r_addr_0_1, w_addr_0_1;
wire [NUMSTAGES-3:0] r_addr_2_3, w_addr_2_3;
reg stage_done;


//---------------- define local variables ---------------------
reg [NUMSTAGES-3:0] counter_r;
wire m0_s_o;
wire [1:0] m1_s_o;
wire m2_s_o;
wire m3_s_o;
wire [NUMSTAGES-3:0] r_addr_0_1_o, w_addr_0_1_o;
wire [NUMSTAGES-3:0] r_addr_2_3_o, w_addr_2_3_o;


//---------------- tristate buffer ---------------------
assign m0_s = en ? m0_s_o : 1'bz;
assign m1_s = en ? m1_s_o : 2'bzz;
assign m2_s = en ? m2_s_o : 1'bz;
assign m3_s = en ? m3_s_o : 1'bz;

assign r_addr_0_1 = en ? r_addr_0_1_o : {NUMSTAGES-2{1'bz}};
assign w_addr_0_1 = en ? w_addr_0_1_o : {NUMSTAGES-2{1'bz}};
assign r_addr_2_3 = en ? r_addr_2_3_o : {NUMSTAGES-2{1'bz}};
assign w_addr_2_3 = en ? w_addr_2_3_o : {NUMSTAGES-2{1'bz}};


//---------------- address generator ---------------------
address_control #(.NUMSTAGES(NUMSTAGES)) acontrol0(
	counter_r, stage_num, 
	r_addr_0_1_o, w_addr_0_1_o,
	r_addr_2_3_o, w_addr_2_3_o
);


//---------------- MUX control signal generator ---------------------
mux_control #(.NUMSTAGES(NUMSTAGES)) mux_ctrl(
	ld_data, counter_r, stage_num, m0_s_o, m1_s_o, m2_s_o, m3_s_o); 


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
		if(counter_r == 3'b110)//3'b111)
			stage_done <= 1'b1;
	end
	else begin 
		counter_r <= {NUMSTAGES-3{1'b0}};
		stage_done <= 1'b0;
	end
end

endmodule
