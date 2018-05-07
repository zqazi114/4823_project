/*
 *	This is the top level module for the fft. 
 *	To initialize RAM from input_data, ld_data <- 1 and watch for ld_done <- 1
 *
 */

module fft_stage(
	//---control signals for this module---//
	clk, 			// clock 
	en,				// tri-state enable
	
	//---stage number for this module---//
	stage_num,

	//---for initializing the RAM with samples---//
	ld_data,		// RAM load signal
	ld_done,		// response from RAM initializer module
	
	//---datapath---//
	data_in0,		// 4 banks, so 4 input data buses
	data_in1,		// " "
	data_in2,		// " "
	data_in3,		// " "
	data_out0,		// 4 banks, so 4 output data buses
	data_out1,		// " "
	data_out2,		// " "
	data_out3,		// " "
	
	//---control---//
	done 			// stage computation completed signal
);


//---------------- parameters ---------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 3;
parameter NUMSTAGES = 5;
parameter NUMSAMPLES = 32;

parameter [2:0] STAGE0 	= 3'b000;
parameter [2:0] STAGE1 	= 3'b001;
parameter [2:0] STAGE2 	= 3'b010;
parameter [2:0] STAGE3 	= 3'b011;
parameter [2:0] STAGE4 	= 3'b100;
parameter [2:0] STAGE5 	= 3'b101;
parameter [2:0] STAGE6 	= 3'b110;
parameter [2:0] STAGE7 	= 3'b111;

//---------------- states ---------------------
parameter [2:0] IDLE 	= 3'b000;	
parameter [2:0] LDRAM 	= 3'b001;
parameter [2:0] RAMRDY 	= 3'b010;
parameter [2:0] RUNNING	= 3'b011;
parameter [2:0] DONE	= 3'b100;


//---------------- define inputs and outputs ---------------------
input clk, en, stage_num, ld_data, data_in0, data_in1, data_in2, data_in3;
output ld_done, done, data_out0, data_out1, data_out2, data_out3;

//---------------- define port types ---------------------
wire clk;
wire en;
wire stage_num;
wire ld_data;
wire ld_done;
wire done;
reg done_r;


//---------------- state registers ---------------------
reg  [2:0] state;
wire [2:0] next_state;


//---------------- datapath wires and regs ---------------------
wire [WORDSIZE-1:0] data_in0, data_in1, data_in2, data_in3;				// input to first mux
wire [WORDSIZE-1:0] bank0_in, bank1_in, bank2_in, bank3_in;				// input to bank0-3
wire [WORDSIZE-1:0] bank0_out, bank1_out, bank2_out, bank3_out;			// input to pe mux
wire [WORDSIZE-1:0] pe_in0, pe_in1, pe_in2, pe_in3;						// input to pe
wire [WORDSIZE-1:0] pe_out0, pe_out1, pe_out2, pe_out3;					// output from pe
wire [WORDSIZE-1:0] m21_out, m22_out, m23_out, m24_out;					// output from pe
wire [WORDSIZE-1:0] data_out0, data_out1, data_out2, data_out3;			// final output wire


//---------------- twiddle wires and regs ---------------------
wire [WORDSIZE-1:0] twiddle_r, twiddle_i;
reg  [NUMSTAGES-3:0] counter_r;

twiddle #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES), .NUMSTAGES(NUMSTAGES)) twiddle0(
	clk,
	ld_twiddle,
	counter_r,
	stage_num,
	twiddle_r,
	twiddle_i
);


//---------------- RAM modules ---------------------
wire [ADDRSIZE-1:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
wire [ADDRSIZE-1:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
reg [ADDRSIZE-1:0] rd_addr0_r, rd_addr1_r, rd_addr2_r, rd_addr3_r;
reg [ADDRSIZE-1:0] wr_addr0_r, wr_addr1_r, wr_addr2_r, wr_addr3_r;
reg rd_en;
reg wr_en;
reg cs;

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank0(
	clk, rd_addr0_r, wr_addr0_r, rd_en, wr_en, cs, bank0_in, bank0_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank1(
	clk, rd_addr1_r, wr_addr1_r, rd_en, wr_en, cs, bank1_in, bank1_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank2(
	clk, rd_addr2_r, wr_addr2_r, rd_en, wr_en, cs, bank2_in, bank2_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank3(
	clk, rd_addr3_r, wr_addr3_r, rd_en, wr_en, cs, bank3_in, bank3_out); 


//---------------- PE ------------------------
pe #(.WORDSIZE(WORDSIZE), .WL(16), .IWL(2), .FWL(13)) pe0(
	pe_in0, pe_in1, pe_in2, pe_in3, twiddle_r, twiddle_i, pe_out0, pe_out1, pe_out2, pe_out3);


//---------------- control signal generator ---------------------
reg en_stage;
wire stage_done;
wire m0_s;
wire [1:0] m1_s;
wire m2_s;
wire m3_s;
wire [ADDRSIZE-1:0] r_addr_0_1, w_addr_0_1;
wire [ADDRSIZE-1:0] r_addr_2_3, w_addr_2_3;

assign rd_addr0 = r_addr_0_1;
assign rd_addr1 = r_addr_0_1;
assign rd_addr2 = r_addr_2_3;
assign rd_addr3 = r_addr_2_3;
assign wr_addr0 = w_addr_0_1;
assign wr_addr1 = w_addr_0_1;
assign wr_addr2 = w_addr_2_3;
assign wr_addr3 = w_addr_2_3;

fft_stage_control #(.NUMSTAGES(NUMSTAGES)) control0(
	clk,
	ld_data,
	en_stage,
	stage_num,
	m0_s, m1_s,	m2_s, m3_s,
	r_addr_0_1, w_addr_0_1,
	r_addr_2_3, w_addr_2_3,
	stage_done
);
	

//---------------- first MUX stage ---------------------
assign bank0_in = data_in0;
assign bank1_in = data_in1;
assign bank2_in = data_in2;
assign bank3_in = data_in3;

//---------------- second MUX stage ---------------------
assign pe_in0 = (m1_s == 2'b00) ? bank0_out : 
				(m1_s == 2'b01) ? bank2_out :
				(m1_s == 2'b10) ? bank0_out : bank0_out;

assign pe_in1 = (m1_s == 2'b00) ? bank1_out : 
				(m1_s == 2'b01) ? bank0_out :
				(m1_s == 2'b10) ? bank2_out : bank2_out;

assign pe_in2 = (m1_s == 2'b00) ? bank2_out : 
				(m1_s == 2'b01) ? bank3_out :
				(m1_s == 2'b10) ? bank1_out : bank1_out;

assign pe_in3 = (m1_s == 2'b00) ? bank3_out : 
				(m1_s == 2'b01) ? bank1_out :
				(m1_s == 2'b10) ? bank3_out : bank3_out;

//---------------- third MUX stage ---------------------
assign m21_out = m2_s ? pe_out0 : pe_out2;
assign m22_out = m2_s ? pe_out1 : pe_out3;
assign m23_out = m2_s ? pe_out2 : pe_out0;
assign m24_out = m2_s ? pe_out3 : pe_out1;

//---------------- output data ---------------------
assign done = done_r;
assign data_out0 = m21_out;
assign data_out1 = m22_out;
assign data_out2 = m23_out;
assign data_out3 = m24_out;


//---------------- code begins here ---------------------
initial
begin
	state 		<= IDLE;
	rd_en 		<= 0;
	wr_en 		<= 0;
	done_r 		<= 0;
	en_stage 	<= 0;
end

//---------------- state logic ---------------------
function [2:0] get_next_state;
	input [2:0] state;
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
			get_next_state = RUNNING;
	 RUNNING :
		if (stage_done && en_stage)
			get_next_state = DONE;
	 DONE : 
		if (~en)
			get_next_state = IDLE;
	 default : get_next_state = IDLE;
	endcase
endfunction

assign next_state = get_next_state(state, ld_data, ld_done, en, stage_done);

integer out_addr;

always @(posedge clk)
begin
	state <= next_state;
	case(state)
		IDLE : begin
			done_r <= 1'b0;
		end
		LDRAM : begin
			en_stage <= 1'b1;
		end
		RAMRDY : begin
			en_stage <= 1'b0;
		end
		RUNNING : begin
			if(stage_done && en_stage)
				en_stage <= 1'b0;
			else if(~en_stage)
				en_stage <= 1'b1;
		end
		DONE : begin
			done_r <= 1'b1;
			en_stage <= 1'b0;
			out_addr = 0;
		end
	endcase
end

integer init_addr;

//---------------- RAM initialization logic ---------------------
always @(posedge clk)
begin
	case(state)
		IDLE : begin
			init_addr = 0;
		end
		LDRAM : begin
			cs <= 1'b1;
			rd_en <= 1'b1;
			wr_en <= 1'b1;
			if(init_addr < NUMSAMPLES/4) begin
				rd_addr0_r <= init_addr;
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
		RAMRDY : begin
			wr_en <= 1'b0;
		end
		RUNNING : begin
			if(stage_done && en_stage)
				wr_en <= 1'b0;
			else 
				wr_en <= 1'b0;
			cs <= 1'b1;
			rd_en <= 1'b1;
		end	
		DONE : begin
			wr_en <= 1'b0;
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
