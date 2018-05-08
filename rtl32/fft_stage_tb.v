/*
 *	This is the testbench for the top level module for the fft. 
 *	To initialize RAM from input_data, ld_data <- 1 and watch for ld_done <- 1
 *
 */

`timescale 1ns/1ps

module fft_stage_tb(
);


//---------------- parameters ---------------------
parameter WORDSIZE = 16;
parameter ADDRSIZE = 5;
parameter NUMSTAGES = 8;
parameter NUMSAMPLES = 256;
parameter TOTALSAMPLES = 10240;

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
parameter [2:0] LOADING	= 3'b001;
parameter [2:0] RUNNING	= 3'b010;
parameter [2:0] DONE	= 3'b011;

//---------------- define local variables ---------------------
reg clk;
reg en_r;
reg wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7;
wire init_error;
reg ld_data_r;
wire ld_done;


//---------------- state registers ---------------------
reg [2:0] state;
wire [2:0] next_state;


//---------------- datapath wires and regs ---------------------
wire [WORDSIZE-1:0] data_in0, data_in1, data_in2, data_in3;			// input to fft wires
wire [WORDSIZE-1:0] st0_in0, st0_in1, st0_in2, st0_in3;				// input to stage 0
wire [WORDSIZE-1:0] st1_in0, st1_in1, st1_in2, st1_in3;				// input to stage 1
wire [WORDSIZE-1:0] st2_in0, st2_in1, st2_in2, st2_in3;				// input to stage 2
wire [WORDSIZE-1:0] st3_in0, st3_in1, st3_in2, st3_in3;				// input to stage 3
wire [WORDSIZE-1:0] st4_in0, st4_in1, st4_in2, st4_in3;				// input to stage 4
wire [WORDSIZE-1:0] st5_in0, st5_in1, st5_in2, st5_in3;				// input to stage 5
wire [WORDSIZE-1:0] st6_in0, st6_in1, st6_in2, st6_in3;				// input to stage 6
wire [WORDSIZE-1:0] st7_in0, st7_in1, st7_in2, st7_in3;				// input to stage 7
wire [WORDSIZE-1:0] st7_out0, st7_out1, st7_out2, st7_out3;				// input to stage 7



//---------------- RAM initializer ---------------------
read_input #(.WORDSIZE(WORDSIZE), .NUMSAMPLES(NUMSAMPLES), .TOTALSAMPLES(TOTALSAMPLES)) r0(
	clk, 
	ld_data_r, init_error, 
	data_in0, data_in1, data_in2, data_in3, 
	ld_done
);

//---------------- FFT module ---------------------
assign st0_in0 = ld_data_r ? data_in0 : {WORDSIZE{1'bz}};
assign st0_in1 = ld_data_r ? data_in1 : {WORDSIZE{1'bz}};
assign st0_in2 = ld_data_r ? data_in2 : {WORDSIZE{1'bz}};
assign st0_in3 = ld_data_r ? data_in3 : {WORDSIZE{1'bz}};

wire [2:0] nstage0 = STAGE0;
wire [2:0] nstage1 = STAGE1;
wire [2:0] nstage2 = STAGE2;
wire [2:0] nstage3 = STAGE3;
wire [2:0] nstage4 = STAGE4;
wire [2:0] nstage5 = STAGE5;
wire [2:0] nstage6 = STAGE6;
wire [2:0] nstage7 = STAGE7;

fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage0(
	clk, en_r, 
	nstage0,
	wr_en0,
	st0_in0, st0_in1, st0_in2, st0_in3, 
	st1_in0, st1_in1, st1_in2, st1_in3, 
);

fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage1(
	clk, en_r, 
	nstage1,
	wr_en1,
	st1_in0, st1_in1, st1_in2, st1_in3, 
	st2_in0, st2_in1, st2_in2, st2_in3, 
);

fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage2(
	clk, en_r, 
	nstage2,
	wr_en2,
	st2_in0, st2_in1, st2_in2, st2_in3, 
	st3_in0, st3_in1, st3_in2, st3_in3, 
);

fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage3(
	clk, en_r, 
	nstage3,
	wr_en3,
	st3_in0, st3_in1, st3_in2, st3_in3, 
	st4_in0, st4_in1, st4_in2, st4_in3, 
);
fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage4(
	clk, en_r, 
	nstage4,
	wr_en4,
	st4_in0, st4_in1, st4_in2, st4_in3, 
	st5_in0, st5_in1, st5_in2, st5_in3, 
);

fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage5(
	clk, en_r, 
	nstage5,
	wr_en5,
	st5_in0, st5_in1, st5_in2, st5_in3, 
	st6_in0, st6_in1, st6_in2, st6_in3, 
);

fft_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage6(
	clk, en_r, 
	nstage6,
	wr_en6,
	st6_in0, st6_in1, st6_in2, st6_in3, 
	st7_in0, st7_in1, st7_in2, st7_in3, 
);
fft_last_stage #(.WORDSIZE(WORDSIZE), .ADDRSIZE(ADDRSIZE), .NUMSTAGES(NUMSTAGES)) stage7(
	clk, en_r, 
	nstage7,
	wr_en7,
	st7_in0, st7_in1, st7_in2, st7_in3, 
	st7_out0, st7_out1, st7_out2, st7_out3, 
	all_done
);

integer file,j;
always@(posedge clk)
begin
if(all_done)
	file = $fopen("verilog_output.dat","w");
	for(j=0;j<NUMSAMPLES;j=j+1)
		$fwrite(file,"%h\n",stage4.bank0.memory[j]);
	for(j=0;j<NUMSAMPLES;j=j+1)
		$fwrite(file,"%h\n",stage4.bank1.memory[j]);
	for(j=0;j<NUMSAMPLES;j=j+1)
		$fwrite(file,"%h\n",stage4.bank2.memory[j]);
	for(j=0;j<NUMSAMPLES;j=j+1)
		$fwrite(file,"%h\n",stage4.bank3.memory[j]);

end





//---------------- code begins here ---------------------

reg [5:0] i; 		// for wr_en

reg [5:0] counter0,counter1,counter2,counter3;
reg [5:0] counter4, counter5, counter6;
reg counter7;

initial
begin
	state <= IDLE;
	clk <= 0;
	ld_data_r <= 0;
	en_r <= 0;
	wr_en0 <= 0;
	i <= 0;
	counter0<=0;
	counter1<=0;
	counter2<=0;
	counter3<=0;
	counter4<=0;
	counter5<=0;
	counter6<=0;
	counter7<=0;
end

always @(*)
begin
	clk <= #0.05 ~clk;
end


//---------------- state logic ---------------------
function [2:0] get_next_state;
	input [2:0] state;
	input ld_data;
	input ld_done;
	input en;
	input [5:0]i;
	
	case (state)
	 IDLE : 
		if (ld_data)
			get_next_state = LOADING;
	 LOADING : 
		if (i == 6'b111111) 
			get_next_state = RUNNING;
	 RUNNING :
		//if (ld_done) 
		if((i == 6'b111111) & (ld_done))
			get_next_state = DONE;
		else if(i==6'b111111)
			get_next_state = LOADING;	//Finish one big cycle, keeping running
	 DONE :
		if (~ld_data)
			get_next_state = IDLE;
	 default : get_next_state = IDLE;
	endcase
endfunction

assign next_state = get_next_state(state, ld_data_r, ld_done, en_r, i);

always @(posedge clk)
begin
		
	if(wr_en0)
		counter0 <= counter0+1;
		if(counter0==6'b111111)
			wr_en1 <= wr_en0;
	if(wr_en1)
		counter1 <= counter1+1;
		if(counter1==6'b111111)
			wr_en2 <= wr_en1;
	if(wr_en2)
		counter2 <= counter2+1;
		if(counter2==6'b111111)
			wr_en3 <= wr_en2;
	if(wr_en3)
		counter3 <= counter3+1;
		if(counter3==6'b111111)
			wr_en4 <= wr_en3;
		//else if(counter4 ==1)
			//wr_en4 <=0;
	if(wr_en4)
		counter4 <= counter4+1;
		if(counter4==6'b111111)
			wr_en5 <= wr_en4;
	if(wr_en5)
		counter5 <= counter5+1;
		if(counter5==6'b111111)
			wr_en6 <= wr_en5;
	if(wr_en6)
		counter6 <= counter6+1;
		if(counter6==6'b111111)
			wr_en7 <= wr_en6;
	if(wr_en7)
		counter7 <= counter7+1;

	state <= next_state;
	case(state)
		IDLE 	: begin 
			ld_data_r <= 1'b1; 
			if(ld_data_r)
				wr_en0 <= 1'b1;
			else
				wr_en0 <= 1'b0;
		end
		LOADING : begin
			i <= i + 5'b1;
			en_r <=1'b1 ;
		end
		RUNNING : begin 
			i <= i + 5'b1;
			wr_en0 <= 1'b1;
			en_r <= 1'b1;
		end
		DONE	: begin 
			wr_en0 <= 1'b0;
			en_r <= 1'b0;
		end
	endcase
end

endmodule
