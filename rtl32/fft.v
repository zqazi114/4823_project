/*
 *	This is the top level module for the fft. 
 *	To initialize RAM from input_data, ld_data <- 1 and watch for ld_done <- 1
 *
 */

module fft(
	//---control signals for this module---//
	clk, 		// clock 
	en,			// tri-state enable
	
	//---for initializing the RAM with samples---//
	ld_data,	// RAM load signal
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
	done 		// stage computation completed signal
);


//---------------- parameters ---------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 3;
parameter NUMSTAGES = 5;
parameter NUMSAMPLES = 32;

//---------------- states ---------------------
parameter [4:0] IDLE 	= 5'b00000;	
parameter [4:0] LDRAM 	= 5'b00001;
parameter [4:0] RAMRDY 	= 5'b00010;
parameter [4:0] STAGE0 	= 5'b00011;
parameter [4:0] STAGE1 	= 5'b00100;
parameter [4:0] STAGE2 	= 5'b00101;
parameter [4:0] STAGE3 	= 5'b00110;
parameter [4:0] STAGE4 	= 5'b00111;
parameter [4:0] DONE	= 5'b01000;


//---------------- define inputs and outputs ---------------------
input clk, en, ld_data, data_in0, data_in1, data_in2, data_in3;
output ld_done, done, data_out0, data_out1, data_out2, data_out3;

//---------------- define port types ---------------------
wire clk;
wire en;
wire ld_data;
wire ld_done;
wire done;
reg done_r;


//---------------- state registers ---------------------
reg  [4:0] state;
wire [4:0] next_state;


//---------------- datapath wires and regs ---------------------
wire [WORDSIZE-1:0] data_in0, data_in1, data_in2, data_in3;				// input to first mux
wire [WORDSIZE-1:0] bank0_in, bank1_in, bank2_in, bank3_in;				// input to bank0-3
wire [WORDSIZE-1:0] bank0_out, bank1_out, bank2_out, bank3_out;			// input to pe mux
wire [WORDSIZE-1:0] pe_in0, pe_in1, pe_in2, pe_in3;						// input to pe
wire [WORDSIZE-1:0] pe_out0, pe_out1, pe_out2, pe_out3;					// output from pe
wire [WORDSIZE-1:0] m21_out, m22_out, m23_out, m24_out;					// output from pe
reg  [WORDSIZE-1:0] data_out0_r, data_out1_r, data_out2_r, data_out3_r;	// final output register
wire [WORDSIZE-1:0] data_out0, data_out1, data_out2, data_out3;			// final output wire


//---------------- twiddle wires and regs ---------------------
wire [WORDSIZE-1:0] twiddle;
reg  [WORDSIZE-1:0] twiddle_r;
reg  [NUMSTAGES-3:0] counter_r;
reg  [2:0] stage_num_r;

assign twiddle = twiddle_r;

twiddle #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES), .NUMSTAGES(NUMSTAGES)) twiddle0(
	clk,
	ld_twiddle,
	counter_r,
	stage_num_r,
	twiddle
);

//---------------- tri-state buffer ---------------------
assign done = done_r;
//assign done 	 = en ? done_r 		: 1'bz;
//assign data_out0 = en ? data_out0_r : {WORDSIZE{1'bz}};
//assign data_out1 = en ? data_out1_r : {WORDSIZE{1'bz}};
//assign data_out2 = en ? data_out2_r : {WORDSIZE{1'bz}};
//assign data_out3 = en ? data_out3_r : {WORDSIZE{1'bz}};


//---------------- RAM modules ---------------------
wire [ADDRSIZE-1:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
wire [ADDRSIZE-1:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
reg [ADDRSIZE-1:0] rd_addr0_r, rd_addr1_r, rd_addr2_r, rd_addr3_r;
reg [ADDRSIZE-1:0] wr_addr0_r, wr_addr1_r, wr_addr2_r, wr_addr3_r;
reg rd_en0, rd_en1, rd_en2, rd_en3;
reg wr_en0, wr_en1, wr_en2, wr_en3;
reg cs0, cs1, cs2, cs3;

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank0(
	clk, rd_addr0_r, wr_addr0_r, rd_en0, wr_en0, cs0, data_in0, data_out0);//bank0_in, bank0_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank1(
	clk, rd_addr1_r, wr_addr1_r, rd_en1, wr_en1, cs1, data_in1, data_out1);//bank1_in, bank1_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank2(
	clk, rd_addr2_r, wr_addr2_r, rd_en2, wr_en2, cs2, data_in2, data_out2);//bank2_in, bank2_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank3(
	clk, rd_addr3_r, wr_addr3_r, rd_en3, wr_en3, cs3, data_in3, data_out3);//bank3_in, bank3_out); 


//---------------- PE ------------------------
pe #(.WORDSIZE(WORDSIZE), .WL(16), .IWL(2), .FWL(13)) pe0(
	pe_in0, pe_in1, pe_in2, pe_in3, twiddle, pe_out0, pe_out1, pe_out2, pe_out3);


//---------------- control signal generator ---------------------
reg en_stage;
reg [2:0] stage_num;
wire stage_done;
wire m0_s;
wire [1:0] m1_s;
wire m2_s;
wire m3_s;

fft_stage_control #(.NUMSTAGES(NUMSTAGES)) control0(
	clk,
	en_stage,
	stage_num,
	m0_s, m1_s,	m2_s, m3_s,
	rd_addr0, rd_addr1, rd_addr2, rd_addr3,
	wr_addr0, wr_addr1, wr_addr2, wr_addr3,
	stage_done
);
	

//---------------- first MUX stage ---------------------
//assign bank0_in = m0_s ? data_in0 : m21_out;
//assign bank1_in = m0_s ? data_in1 : m22_out;
//assign bank2_in = m0_s ? data_in2 : m23_out;
//assign bank3_in = m0_s ? data_in3 : m24_out;


//---------------- second MUX stage ---------------------
//assign pe_in0 = (m1_s == 2'b00) ? data_out0 : 
//				(m1_s == 2'b01) ? data_out0 :
//				(m1_s == 2'b10) ? data_out2 : data_out2 ;

assign pe_in1 = (m1_s == 2'b00) ? data_out0 : 
				(m1_s == 2'b01) ? data_out0 :
				(m1_s == 2'b10) ? data_out2 : data_out2 ;

assign pe_in2 = (m1_s == 2'b00) ? data_out0 : 
				(m1_s == 2'b01) ? data_out0 :
				(m1_s == 2'b10) ? data_out2 : data_out2 ;

assign pe_in3 = (m1_s == 2'b00) ? data_out0 : 
				(m1_s == 2'b01) ? data_out0 :
				(m1_s == 2'b10) ? data_out2 : data_out2 ;


//---------------- third MUX stage ---------------------
assign m21_out = m2_s ? pe_out0 : pe_out2;
assign m22_out = m2_s ? pe_out1 : pe_out3;
assign m23_out = m2_s ? pe_out0 : pe_out2;
assign m24_out = m2_s ? pe_out1 : pe_out3;


//---------------- code begins here ---------------------
initial
begin
	state 		<= IDLE;
	rd_en0 		<= 0;
	rd_en1 		<= 0;
	rd_en2 		<= 0;
	rd_en3 		<= 0;
	wr_en0 		<= 0;
	wr_en1 		<= 0;
	wr_en2 		<= 0;
	wr_en3 		<= 0;
	done_r 		<= 0;
	stage_num	<= 0;
	data_out0_r <= 0;
	data_out1_r <= 0;	
	data_out2_r <= 0;	
	data_out3_r <= 0;	
	en_stage 	<= 0;
end

//---------------- state logic ---------------------
function [4:0] get_next_state;
	input [4:0] state;
	input ld_data;
	input ld_done;
	input en;
	input stage_done;

	case (state)
	 IDLE : 
		if (ld_data)
			get_next_state = LDRAM;
	 LDRAM : 
		if (ld_done)
			get_next_state = RAMRDY;
	 RAMRDY : 
		if (en)
			get_next_state = STAGE0;
	 STAGE0 :
		if (stage_done && en_stage)
			get_next_state = STAGE1;
	 STAGE1 :
		if (stage_done && en_stage)
			get_next_state = STAGE2;
	 STAGE2 :
		if (stage_done && en_stage)
			get_next_state = STAGE3;
	 STAGE3 :
		if (stage_done && en_stage)
			get_next_state = STAGE4;
	 STAGE4 :
		if (stage_done && en_stage)
			get_next_state = DONE;
	 DONE : 
		if (~en)
			get_next_state = IDLE;
	 default : get_next_state = IDLE;
	endcase
endfunction

assign next_state = get_next_state(state, ld_data, ld_done, en, stage_done);

always @(posedge clk)
begin
	state <= next_state;
	stage_num <= state - 3'b011;
	case(state)
		IDLE : begin
			done_r <= 1'b0;
		end
		STAGE0, STAGE1, STAGE2, STAGE3, STAGE4 : begin
			if(stage_done && en_stage)
				en_stage <= 1'b0;
			else if(~en_stage)
				en_stage <= 1'b1;
		end
		DONE : begin
			done_r <= 1'b1;
			en_stage <= 1'b0;
		end
	endcase
end

integer init_addr;

//---------------- RAM initialization logic ---------------------
always @(posedge clk)
begin
	cs0    <= 1'b1;
	cs1    <= 1'b1;
	cs2    <= 1'b1;
	cs3    <= 1'b1;
	rd_en0 <= 1'b1;
	rd_en1 <= 1'b1;
	rd_en2 <= 1'b1;
	rd_en3 <= 1'b1;	
	wr_en0 <= 1'b1;
	wr_en1 <= 1'b1;
	wr_en2 <= 1'b1;
	wr_en3 <= 1'b1;
	
	case(state)
		IDLE : begin
			init_addr = 0;
		end
		LDRAM : begin
			if(init_addr < NUMSAMPLES/4) begin
				//rd_addr0_r <= init_addr;
				rd_addr1_r <= init_addr;
				rd_addr2_r <= init_addr;
				rd_addr3_r <= init_addr;
				wr_addr0_r <= init_addr;
				wr_addr1_r <= init_addr;
				wr_addr2_r <= init_addr;
				wr_addr3_r <= init_addr;
			end
			init_addr = init_addr + 1;
		end 
		default : begin
			rd_addr0_r <= rd_addr0;
			rd_addr1_r <= rd_addr1;
			rd_addr2_r <= rd_addr2;
			rd_addr3_r <= rd_addr3;
			wr_addr0_r <= wr_addr0;
			wr_addr1_r <= wr_addr1;
			wr_addr2_r <= wr_addr2;
			wr_addr3_r <= wr_addr3;
		end	
	endcase
end

endmodule
