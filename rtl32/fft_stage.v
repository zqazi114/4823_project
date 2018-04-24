/*
 *	This is the top level module for the fft_stage. 
 *	To initialize RAM from input_data, ld_data <- 1 and watch for ld_done <- 1
 *
 *
 */

module fft_stage(
	//---control signals for this module---//
	clk, 		// clock 
	en,			// tri-state enable
	stage_num,	// stage number for address/mux computation
	
	//---for initializing the RAM with samples---//
	ld_data,	// load signal to RAM to load the initial data
	ld_done,	// response from RAM initializer module
	
	//---datapath---//
	data_in0,	// 4 banks, so 4 input data buses
	data_in1,	// " "
	data_in2,	// " "
	data_in3,	// " "
	data_out0,	// 4 banks, so 4 output data buses
	data_out1,	// " "
	data_out2,	// " "
	data_out3,	// " "
	
	//---control---//
	counter,	// clock cycle counter
	done 		// stage computation completed signal
);


//---------------- parameters ---------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 8;


//---------------- states ---------------------
parameter [4:0] IDLE = 5'b00000;	
parameter [4:0] LDRAM = 5'b00001;
parameter [4:0] RAMRDY = 5'b00010;


//---------------- define inputs and outputs ---------------------
input clk, en, stage_num, ld_data, data_in0, data_in1, data_in2, data_in3;
output ld_done, counter, done, data_out0, data_out1, data_out2, data_out3;


//---------------- define port types ---------------------
wire clk;
wire en;
wire [2:0] stage_num;
wire ld_data;
wire ld_done;
wire [5:0] counter;
wire done;
reg [5:0] counter_r;
reg done_r;


//---------------- state registers ---------------------
reg [4:0] state;
wire [4:0] next_state;


//---------------- mux control signals ---------------------
wire m0_s;
wire [1:0] m11_s, m12_s, m13_s, m14_s;
wire m21_s, m22_s, m23_s, m24_s;


//---------------- datapath wires and regs ---------------------
wire [WORDSIZE-1:0] data_in0, data_in1, data_in2, data_in3;				// input to first mux
wire [WORDSIZE-1:0] bank0_in, bank1_in, bank2_in, bank3_in;				// input to bank0-3
wire [WORDSIZE-1:0] bank0_out, bank1_out, bank2_out, bank3_out;			// input to pe mux
wire [WORDSIZE-1:0] pe_in0, pe_in1, pe_in2, pe_in3;						// input to pe
wire [WORDSIZE-1:0] pe_out0, pe_out1, pe_out2, pe_out3;					// output from pe
wire [WORDSIZE-1:0] m21_out, m22_out, m23_out, m24_out;					// output from pe
reg  [WORDSIZE-1:0] data_out0_r, data_out1_r, data_out2_r, data_out3_r;	// final output register
wire [WORDSIZE-1:0] data_out0, data_out1, data_out2, data_out3;			// final output wire


//---------------- ram inputs and outputs ---------------------
reg [ADDRSIZE-1:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
reg [ADDRSIZE-1:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
reg rd_en0, rd_en1, rd_en2, rd_en3;
reg wr_en0, wr_en1, we_en2, wr_en3;
reg cs0, cs1, cs2, cs3;


//---------------- twiddle wires and regs ---------------------
wire [WORDSIZE-1:0] twiddle;
reg [WORDSIZE-1:0] twiddle_r;

assign twiddle = twiddle_r;


//---------------- tri-state buffer ---------------------
assign counter 	 = en ? counter_r : 5'bz;
assign done 	 = en ? done_r : 1'bz;
assign data_out0 = en ? data_out0_r : {WORDSIZE{1'bz}};
assign data_out1 = en ? data_out1_r : {WORDSIZE{1'bz}};
assign data_out2 = en ? data_out2_r : {WORDSIZE{1'bz}};
assign data_out3 = en ? data_out3_r : {WORDSIZE{1'bz}};


//---------------- RAM initializer ---------------------
reg init_error;
reg ld_done_r;

read_input #(.WORDSIZE(WORDSIZE), .NUMSAMPLES(32)) r0(
	clk, init_error, bank0_in, bank1_in, bank2_in, bank3_in, ld_done_r);


//---------------- RAM modules ---------------------
ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE)) bank0(
	clk, rd_addr0, wr_addr0, rd_en0, wr_en0, cs0, bank0_in, bank0_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE)) bank1(
	clk, rd_addr1, wr_addr1, rd_en1, wr_en1, cs1, bank1_in, bank1_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE)) bank2(
	clk, rd_addr2, wr_addr2, rd_en2, wr_en2, cs2, bank2_in, bank2_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE)) bank3(
	clk, rd_addr3, wr_addr3, rd_en3, wr_en3, cs3, bank3_in, bank3_out); 


//---------------- PE ---------------------
pe #(.WORDSIZE(WORDSIZE), .WL(16), .IWL(2), .FWL(13)) pe0(
	pe_in0, pe_in1, pe_in2, pe_in3, twiddle, pe_out0, pe_out1, pe_out2, pe_out3);


//---------------- MUX control signal generator ---------------------
mux_controls mux_ctrl(
	counter, stage_num, m0_s, m11_s, m12_s, m13_s, m14_s, m21_s, m22_s, m23_s, m24_s); 


//---------------- first MUX stage ---------------------
assign bank0_in = m0_s ? data_in0 : m21_out;
assign bank1_in = m0_s ? data_in1 : m22_out;
assign bank2_in = m0_s ? data_in2 : m23_out;
assign bank3_in = m0_s ? data_in3 : m24_out;


//---------------- second MUX stage ---------------------
assign pe_in0 = (m11_s == 2'b00) ? data_out0 : 
				(m11_s == 2'b01) ? data_out0 :
				(m11_s == 2'b10) ? data_out2 : data_out2 ;

assign pe_in1 = (m12_s == 2'b00) ? data_out0 : 
				(m12_s == 2'b01) ? data_out1 :
				(m12_s == 2'b10) ? data_out2 : data_out2 ;

assign pe_in2 = (m13_s == 2'b00) ? data_out1 : 
				(m13_s == 2'b01) ? data_out2 :
				(m13_s == 2'b10) ? data_out3 : data_out3 ;

assign pe_in3 = (m14_s == 2'b00) ? data_out1 : 
				(m14_s == 2'b01) ? data_out1 :
				(m14_s == 2'b10) ? data_out3 : data_out3 ;


//---------------- third MUX stage ---------------------
assign m21_out = m21_s ? pe_out0 : pe_out2;
assign m22_out = m22_s ? pe_out1 : pe_out3;
assign m23_out = m23_s ? pe_out0 : pe_out2;
assign m24_out = m24_s ? pe_out1 : pe_out3;


//---------------- code begins here ---------------------
initial
begin
	state 		<= IDLE;
	counter_r 	<= 0;
	done_r 		<= 0;
	data_out0_r <= 0;
	data_out1_r <= 0;	
	data_out2_r <= 0;	
	data_out3_r <= 0;	
end

//---------------- state logic ---------------------
function [4:0] get_next_state;
	input [4:0] state;
	input ld_data;
	input ld_done;

	case (state)
	 IDLE : 
		if (ld_data)
			get_next_state = LDRAM;
	 LDRAM : 
		if (ld_done)
			get_next_state = RAMRDY;
	 default : get_next_state = IDLE;
	endcase
endfunction

assign next_state = en ? get_next_state(state, ld_data, ld_done_r) : 5'bzzzzz;

always @(posedge clk)
begin
	state <= next_state;	
end

//---------------- datapath logic ---------------------
always @(posedge clk)
begin
	counter_r <= counter_r + 1;
end

//---------------- control logic ---------------------
endmodule
