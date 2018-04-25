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
	stage_done	// stage completed
);


//---------------- parameters ---------------------
parameter NUMSTAGES = 5;


//---------------- define inputs and outputs ---------------------
input clk, en, stage_num;
output m0_s, m1_s, m2_s, m3_s, stage_done;


//---------------- define port types ---------------------
wire clk;
wire en;
wire [2:0] stage_num;
wire m0_s;
wire [1:0] m1_s;
wire m2_s;
wire m3_s;
reg stage_done;


//---------------- define local variables ---------------------
reg [NUMSTAGES-3:0] counter_r;

//---------------- MUX control signal generator ---------------------
mux_control mux_ctrl(
	counter_r, stage_num, m0_s, m1_s, m2_s, m3_s); 


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
