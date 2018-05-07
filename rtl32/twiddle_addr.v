module twiddle_addr(
	counter,
	tw_addr
);
parameter [3:0] stage;


input counter;
output tw_addr;
wire [3:0] counter;
wire [3:0] tw_addr;

always@(counter)
begin
case(stage)
	4'b0:  tw_addr = counter;
	4'b1: 
		if counter[2] == 0
			tw_addr = counter[1:0] << 1;
		else
			tw_addr = counter[1:0] << 2;
	4'b10:
		if counter[2:1] == 2'b0
			tw_addr = counter[0] << 2;
		else
			tw_addr = counter[0] << 3;
	default:
		tw_addr = 0;
	endcase

end

endmodule
