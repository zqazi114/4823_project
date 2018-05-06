module pe(
	in0,		// 0: input
	in1,		// 1: input
	in2,		// 2: input
	in3,		// 3: input
	twiddle_r,	// real twiddle factor
	twiddle_i,	// imaginary twiddle factor
	out0,		// 0: output
	out1,		// 1: output
	out2,		// 2: output
	out3		// 3: output
);

//-----------------parameters----------------------------
parameter WORDSIZE = 16;
parameter WL=16, IWL=2, FWL=10;


// ----------------define inputs and outputs----------------------------
input in0,in1,in2,in3,twiddle_r,twiddle_i;
output out0,out1,out2,out3;

// ----------------define port types----------------------------
wire [WORDSIZE-1:0] in0,in1,in2,in3,twiddle_r, twiddle_i;
wire [WORDSIZE-1:0] out0,out1,out2,out3;

// ----------------define local variables----------------------------
wire [WORDSIZE-1:0] in1_neg, in3_neg;
wire [WORDSIZE-1:0] in20, in30;
wire [WORDSIZE-1:0] out20, out21, out30, out31, out31_neg;
wire ovr20, ovr21, ovr30, ovr31;

// ----------------code begins here----------------------------
assign in1_neg = {~in1[WORDSIZE-1],in1[WORDSIZE-2:0]};
assign in3_neg = {~in3[WORDSIZE-1],in3[WORDSIZE-2:0]};

// ----------------modules----------------------------
qadd #(FWL,WL) add0(
	.a(in0),
	.b(in1),
	.c(out0)
);
qadd #(FWL,WL) add1(
	.a(in2),
	.b(in3),
	.c(out1)
);
qadd #(FWL,WL) add2(
	.a(in0),
	.b(in1_neg),
	.c(in20)
);
qadd #(FWL,WL) add3(
	.a(in2),
	.b(in3_neg),
	.c(in30)
);
qmult #(FWL,WL) mult0(
	.i_multiplicand(in20),
	.i_multiplier(twiddle_r),
	.o_result(out20),
	.ovr(ovr20)
);
qmult #(FWL,WL) mult1(
	.i_multiplicand(in30),
	.i_multiplier(twiddle_i),
	.o_result(out21),
	.ovr(ovr21)
);
qadd #(FWL,WL) add4(
	.a(out20),
	.b(out21),
	.c(out2)
);
qmult #(FWL,WL) mult2(
	.i_multiplicand(in30),
	.i_multiplier(twiddle_r),
	.o_result(out30),
	.ovr(ovr30)
);
qmult #(FWL,WL) mult3(
	.i_multiplicand(in20),
	.i_multiplier(twiddle_i),
	.o_result(out31),
	.ovr(ovr31)
);
assign out31_neg = { ~out31[WORDSIZE-1], out31[WORDSIZE-2:0] };

qadd #(FWL,WL) add5(
	.a(out30),
	.b(out31_neg),
	.c(out3)
);
endmodule
