/*
 *	This is the testbench for the top level module for the fft. 
 *	To initialize RAM from input_data, ld_data <- 1 and watch for ld_done <- 1
 *
 */

`timescale 1ns/1ps

module fft_tb(
);


//---------------- parameters ---------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 3;
parameter NUMSTAGES = 5;

//---------------- states ---------------------
parameter [2:0] IDLE 	= 3'b000;	
parameter [2:0] LDRAM 	= 3'b001;
parameter [2:0] RAMRDY 	= 3'b010;
parameter [2:0] RUNNING	= 3'b011;
parameter [2:0] DONE	= 3'b100;
parameter [2:0] OUTPUT  = 3'b101;

//---------------- define local variables ---------------------
reg clk;
reg en_r;
wire init_error;
reg ld_data_r;
wire ld_done;
reg output_data_r;
wire done;


//---------------- state registers ---------------------
reg [4:0] state;
wire [4:0] next_state;


//---------------- datapath wires and regs ---------------------
wire [WORDSIZE-1:0] fft_in0, fft_in1, fft_in2, fft_in3;				// input to fft wires
wire [WORDSIZE-1:0] fft_out0, fft_out1, fft_out2, fft_out3;			// output from fft wire



//---------------- RAM initializer ---------------------
read_input #(.WORDSIZE(WORDSIZE), .NUMSAMPLES(32)) r0(
	clk, 
	ld_data_r, init_error, 
	fft_in0, fft_in1, fft_in2, fft_in3, 
	ld_done
);

//---------------- FFT module ---------------------
fft #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) fft0(
	clk, en_r, 
	ld_data_r, ld_done, 
	output_data_r,
	fft_in0, fft_in1, fft_in2, fft_in3, 
	fft_out0, fft_out1, fft_out2, fft_out3, 
	done
);


//---------------- code begins here ---------------------
initial
begin
	state <= IDLE;
	clk <= 0;
	ld_data_r <= 0;
	en_r <= 0;
	output_data_r <= 0;
end

always @(*)
begin
	clk <= #0.05 ~clk;
end


//---------------- state logic ---------------------
function [4:0] get_next_state;
	input [4:0] state;
	input ld_data;
	input ld_done;
	input en;
	input done;

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
		if (done) 
			get_next_state = DONE;
	 DONE :
		if (~ld_data)
			get_next_state = OUTPUT;
	 OUTPUT :
		if (~done)
			get_next_state = IDLE;
	 default : get_next_state = IDLE;
	endcase
endfunction

assign next_state = get_next_state(state, ld_data_r, ld_done, en_r, done);

always @(posedge clk)
begin
	state <= next_state;
	case(state)
		IDLE 	: ld_data_r <= 1'b1; 
		LDRAM 	: ;
		RAMRDY  : en_r <= 1'b1;
		RUNNING : en_r <= 1'b1;
		DONE	: begin 
			en_r <= 1'b0;
			ld_data_r <= #5 1'b0;
		end
		OUTPUT  : begin
			 output_data_r <= 1'b1;
			 output_data_r <= #5 1'b1;
			 output_data_r <= 1'b1;
		end
	endcase
end

endmodule
