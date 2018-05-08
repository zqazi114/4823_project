`timescale 1ns/1ps
/*
 *	This is the top level module for the fft. 
 *	To initialize RAM from input_data, ld_data <- 1 and watch for ld_done <- 1
 *
 */

module fft_last_stage(
	//---control signals for this module---//
	clk, 			// clock 
	en,				// tri-state enable
	stage_num,		// which stage is this
	wr_en,			// write enable from previous stage
	
	//---datapath---//
	data_in0,		// 4 banks, so 4 input data buses
	data_in1,		// " "
	data_in2,		// " "
	data_in3,		// " "
	data_out0,		// 4 banks, so 4 output data buses
	data_out1,		// " "
	data_out2,		// " "
	data_out3,		// " "
	all_done
);


//---------------- parameters ---------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 8;
parameter NUMSTAGES = 8;
parameter NUMSAMPLES = 256;

parameter [2:0] STAGE0  = 3'b000;
parameter [2:0] STAGE1  = 3'b001;
parameter [2:0] STAGE2  = 3'b010;
parameter [2:0] STAGE3  = 3'b011;
parameter [2:0] STAGE4  = 3'b100;
parameter [2:0] STAGE5  = 3'b101;
parameter [2:0] STAGE6  = 3'b110;
parameter [2:0] STAGE7  = 3'b111;

	
//---------------- states ---------------------
parameter [2:0] IDLE 	= 3'b000;	
parameter [2:0] RUNNING = 3'b001;
parameter [2:0] DONE	= 3'b010;
parameter [2:0] LOADING	= 3'b011;

//---------------- define inputs and outputs ---------------------
input clk, en, stage_num, wr_en, data_in0, data_in1, data_in2, data_in3;
output data_out0, data_out1, data_out2, data_out3;
output reg all_done;

//---------------- define port types ---------------------
wire clk;
wire en;
wire [2:0] stage_num;
wire wr_en;


//---------------- state registers ---------------------
reg  [2:0] state;
wire [2:0] next_state;


//---------------- datapath wires and regs ---------------------
wire [WORDSIZE-1:0] data_in0, data_in1, data_in2, data_in3;				// input to first mux
wire [WORDSIZE-1:0] bank0_in, bank1_in, bank2_in, bank3_in;				// input to bank0-3
wire [WORDSIZE-1:0] bank0_out, bank1_out, bank2_out, bank3_out;			// input to pe mux
wire [WORDSIZE-1:0] pe_in0, pe_in1, pe_in2, pe_in3;						// input to pe
wire [WORDSIZE-1:0] pe_out0, pe_out1, pe_out2, pe_out3;					// output from pe
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
reg [ADDRSIZE-1:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
reg write_back;
reg cs;
reg rd_en;
reg ram_wr_en;
always@(state or wr_en or counter_r)
begin
	if(state==LOADING)
	begin
		ram_wr_en = wr_en;
		write_back = 0;
	end
	else if((state ==RUNNING) & (counter_r ==1))
	begin
		ram_wr_en = 1;
		write_back = 1;
	end
	else
	begin
		write_back =0;
		ram_wr_en = 0;
	end
end
always@(posedge clk)
begin
	if(write_back)
		all_done = 1;
	else
		all_done = 0;
end


ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank0(
	clk, rd_addr0, wr_addr0, rd_en, ram_wr_en, cs, bank0_in, bank0_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank1(
	clk, rd_addr1, wr_addr1, rd_en, ram_wr_en, cs, bank1_in, bank1_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank2(
	clk, ~rd_addr0, wr_addr2, rd_en, wr_en, cs, bank2_in, bank2_out); 

ram #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMADDR(NUMSAMPLES/4)) bank3(
	clk, ~rd_addr0, wr_addr3, rd_en, wr_en, cs, bank3_in, bank3_out); 


//---------------- PE ------------------------
pe #(.WORDSIZE(WORDSIZE), .WL(16), .IWL(2), .FWL(10)) pe0(
	pe_in0, pe_in1, pe_in2, pe_in3, twiddle_r, twiddle_i, pe_out0, pe_out1, pe_out2, pe_out3);


//---------------- control signal generator ---------------------
reg en_stage;
wire stage_done;
reg ld_data;
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

always@(posedge clk)
begin
 wr_addr0 <= w_addr_0_1;
 wr_addr1 <= w_addr_0_1;
 wr_addr2 <= w_addr_2_3;
 wr_addr3 <= w_addr_2_3;
end



fft_stage_control #(.NUMSTAGES(NUMSTAGES)) control0(
	clk,
	ld_data,
	wr_en, //en_stage,
	stage_num,
	m0_s, m1_s,	m2_s, m3_s,
	r_addr_0_1, w_addr_0_1,
	r_addr_2_3, w_addr_2_3,
	stage_done
);
	

//---------------- first MUX stage ---------------------
//Writeback
assign bank0_in = write_back?pe_out0:data_in0;
assign bank1_in = write_back?pe_out2:data_in1;
assign bank2_in = data_in2;
assign bank3_in = data_in3;

//---------------- second MUX stage ---------------------
assign pe_in0 = bank0_out;

assign pe_in1 =  bank1_out;

assign pe_in2 = bank2_out;
	
assign pe_in3 = bank3_out;

				

//---------------- third MUX stage ---------------------
assign data_out0 = ~(state==RUNNING)?16'hzzzz:write_back ? pe_out0: bank0_out;
assign data_out1 = ~(state==RUNNING)?16'hzzzz:write_back ? pe_out2: bank1_out;
assign data_out2 = ~(state==RUNNING)?16'hzzzz: bank2_out ;
assign data_out3 = ~(state==RUNNING)?16'hzzzz: bank3_out ;


//---------------- code begins here ---------------------
initial
begin
	state <= IDLE;
	rd_en <= 0;
	counter_r <= 0;
	ld_data <=0;
	write_back <= 0;
end

//---------------- state logic ---------------------
function [2:0] get_next_state;
	input wr_en;
	input [2:0] state;
	input en;
	input stage_done;
	input [5:0] counter_r;

	case (state)
	 IDLE : 
		if (wr_en)
		begin
			get_next_state = LOADING;
			ld_data = 1;
		end
	 LOADING:
		if(counter_r==0)
		begin
			get_next_state = RUNNING;
			ld_data = 0;
		end
	 RUNNING :
		if (~wr_en)
			get_next_state = DONE;
		else if(counter_r==0)
			get_next_state = LOADING;
	 DONE : 
		if (~en)
			get_next_state = IDLE;
	 default : get_next_state = IDLE;
	endcase
endfunction

assign next_state = get_next_state(wr_en, state, en, stage_done,counter_r);

always @(posedge clk)
begin
	state <= next_state;
	cs <= 1'b1;
	rd_en <= 1'b1;
	if(wr_en)
		counter_r <= counter_r + 1;
	else
		counter_r <= 0;
end

endmodule