module address_control(
	counter,		// clock counter
	stage_num,		// stage number
    r_addr_0_1, 	// 0,1: read address
    w_addr_0_1, 	// 0,1: write address
    r_addr_2_3,		// 2,3: read address
    w_addr_2_3 		// 2,3: write address
);

// ------------------------ parameters  ------------------------------
parameter NUMSTAGES = 5;


// ------------------------ states  ------------------------------
parameter 	STAGE0 = 3'b000, 
		  	STAGE1 = 3'b001, 
		  	STAGE2 = 3'b010, 
			STAGE3 = 3'b011, 
			STAGE4 = 3'b100; 


// ------------------------ define inputs and outputs ------------------------------
input counter, stage_num;
output r_addr_0_1, w_addr_0_1;
output r_addr_2_3, w_addr_2_3;


// ------------------------ define port types ------------------------------
wire [NUMSTAGES-3:0] counter;
wire [2:0] stage_num;
wire [NUMSTAGES-3:0] r_addr_0_1, w_addr_0_1;
wire [NUMSTAGES-3:0] r_addr_2_3, w_addr_2_3;

// ------------------------ define local variables ------------------------------
reg [NUMSTAGES-3:0] r_addr_0_1_r, w_addr_0_1_r;
reg [NUMSTAGES-3:0] r_addr_2_3_r, w_addr_2_3_r;


// ------------------------ code begins here ------------------------------
assign r_addr_0_1 = r_addr_0_1_r;
assign w_addr_0_1 = w_addr_0_1_r;
assign r_addr_2_3 = r_addr_2_3_r;
assign w_addr_2_3 = w_addr_2_3_r;


always @(counter, stage_num) 
begin
	r_addr_0_1_r <= counter;
	w_addr_0_1_r <= counter;

	case(stage_num)
		STAGE0 : begin
			r_addr_2_3_r <= counter;
			w_addr_2_3_r <= {NUMSTAGES-2{1'bz}};
		end
		STAGE1 : begin
			r_addr_2_3_r <= { ~counter[NUMSTAGES-3], counter[NUMSTAGES-4:0] };
			w_addr_2_3_r <= counter;
		end
		STAGE2 : begin
			r_addr_2_3_r <= { ~counter[NUMSTAGES-3:NUMSTAGES-4], counter[NUMSTAGES-5:0] };
			w_addr_2_3_r <= { ~counter[NUMSTAGES-3], counter[NUMSTAGES-4:0] };
		end
		STAGE3 : begin
			r_addr_2_3_r <= ~counter;//{ ~counter[NUMSTAGES-3:NUMSTAGES-5], counter[NUMSTAGES-6:0] };
			w_addr_2_3_r <= { ~counter[NUMSTAGES-3:NUMSTAGES-4], counter[NUMSTAGES-5:0] };
		end
		STAGE4 : begin
			r_addr_2_3_r <= {NUMSTAGES-2{1'b0}};//{ ~counter[NUMSTAGES-3], counter[NUMSTAGES-4:0] };
			w_addr_2_3_r <= ~counter;
		end
	endcase
end

endmodule
