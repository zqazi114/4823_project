module pe(
	in0,		// inputs
	in1,
	in2,
	in3,
	twiddle,	// twiddle factor
	out0,		// outputs
	out1,
	out2,
	out3
);

//-----------------parameters----------------------------
parameter WORDSIZE = 16;
parameter WL=16, IWL=2, FWL=10;


// ----------------define inputs and outputs----------------------------
input in0,in1,in2,in3,twiddle;
output out0,out1,out2,out3;

// ----------------define port types----------------------------
wire [WORDSIZE-1:0] in0,in1,in2,in3,twiddle;
wire [WORDSIZE-1:0] out0,out1,out2,out3;

// ----------------define local variables----------------------------
wire [WORDSIZE-1:0] in1_neg, in3_neg;
wire [WORDSIZE-1:0] out20, out30;
wire ovr2, ovr3;

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
	.c(out20)
);
qadd #(FWL,WL) add3(
	.a(in2),
	.b(in3_neg),
	.c(out30)
);
qmult #(FWL,WL) mult0(
	.i_multiplicand(out20),
	.i_multiplier(twiddle),
	.o_result(out2),
	.ovr(ovr2)
);
qmult #(FWL,WL) mult1(
	.i_multiplicand(out30),
	.i_multiplier(twiddle),
	.o_result(out3),
	.ovr(ovr3)
);

endmodule
