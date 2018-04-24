/*
 *	This module reads a whole input file in the format shown below with the
 *	assigned name and outputs 4 contiguous 16-bit words each clock cycle
 *
 *	file name: input.dat
 *	file format: @{address} {data}
 *		e.g. @1F 67
 *			 @20 99
 *
 */

module read_input(
	clk,		// clock
	error,		// error during reading
	data_out0,	// word 0 
	data_out1,	// word 1
	data_out2,	// word 2
	data_out3,	// word 3
	done		// asserted when finished reading
);

`define NULL 0


// ----------------------------- parameters ------------------------------------
parameter WORDSIZE = 16;	// number of bits per word
parameter NUMSAMPLES = 32;	// number of samples being read


// ---------------------- define inputs and outputs ------------------------------------
input clk;
output error, data_out0, data_out1, data_out2, data_out3, done;


// ------------------------- define port types  ------------------------------------
wire clk;
reg error;
reg done;
reg [WORDSIZE-1:0] data_out0, data_out1, data_out2, data_out3;


// ------------------------- local variables ------------------------------------
reg [WORDSIZE-1:0] samples [0:NUMSAMPLES-1]; // memory array to hold samples read from input.dat


integer i; // used to index sample number


// ------------------------code begins here  ------------------------------------
initial
begin
	i = 0;
	error <= 1'b0;
	done <= 1'b0;
	data_out0 <= {WORDSIZE{1'b0}};
	data_out1 <= {WORDSIZE{1'b0}};
	data_out2 <= {WORDSIZE{1'b0}};
	data_out3 <= {WORDSIZE{1'b0}};
	$readmemh("input.dat", samples);
end

always @(posedge clk)
begin
	if(i < NUMSAMPLES) begin
		data_out0 <= samples[i];
		data_out1 <= samples[i+1];
		data_out2 <= samples[i+2];
		data_out3 <= samples[i+3];
		i = i + 4;			
	end	else begin
		done <= 1'b1;
	end
end

endmodule
