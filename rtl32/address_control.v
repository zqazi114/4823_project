module address_control(
	counter,		// clock counter
	stage_num,		// stage number
	rd_addr0,		// 0: read addresses
	rd_addr1,		// 1:
	rd_addr2,		// 2: 
	rd_addr3,		// 3:
	wr_addr0,		// 0: write addresses
	wr_addr1,		// 1:
	wr_addr2,		// 2:
	wr_addr3,		// 3:
);

// ------------------------ parameters  ------------------------------
parameter NUMSTAGES = 5;


// ------------------------ states  ------------------------------
parameter STAGE0 = 3'b000, STAGE1 = 3'b001, STAGE2 = 3'b010, STAGE3 = 3'b011, STAGE4 = 3'b100; 


// ------------------------ define inputs and outputs ------------------------------
input counter, stage_num;
output rd_addr0, rd_addr1, rd_addr2, rd_addr3;
output wr_addr0, wr_addr1, wr_addr2, wr_addr3;


// ------------------------ define port types ------------------------------
wire [NUMSTAGES-3:0] counter;
wire [2:0] stage_num;
wire [NUMSTAGES-3:0] rd_addr0, rd_addr1, rd_addr2, rd_addr3;
wire [NUMSTAGES-3:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;


// ------------------------ define local variables ------------------------------
reg [NUMSTAGES-3:0] rd_addr0_r, rd_addr1_r, rd_addr2_r, rd_addr3_r;
reg [NUMSTAGES-3:0] wr_addr0_r, wr_addr1_r, wr_addr2_r, wr_addr3_r;


// ------------------------ code begins here ------------------------------
assign rd_addr0 = rd_addr0_r;
assign rd_addr1 = rd_addr1_r;
assign rd_addr2 = rd_addr2_r;
assign rd_addr3 = rd_addr3_r;

assign wr_addr0 = wr_addr0_r;
assign wr_addr1 = wr_addr1_r;
assign wr_addr2 = wr_addr2_r;
assign wr_addr3 = wr_addr3_r;


always @(counter, stage_num) 
begin
	rd_addr0_r <= counter;
	wr_addr0_r <= counter;
	rd_addr1_r <= counter;
	wr_addr1_r <= counter;

	case(stage_num)
		STAGE0, STAGE1 : begin
			rd_addr2_r <= { ~counter[NUMSTAGES-3], counter[NUMSTAGES-4:0] };
			wr_addr2_r <= counter;	
			rd_addr3_r <= { ~counter[NUMSTAGES-3], counter[NUMSTAGES-4:0] };
			wr_addr3_r <= counter;
		end
		STAGE2 : begin
			rd_addr2_r <= { ~counter[NUMSTAGES-3:NUMSTAGES-4], counter[NUMSTAGES-5:0] };
			wr_addr2_r <= { ~counter[NUMSTAGES-3:NUMSTAGES-4], counter[NUMSTAGES-5:0] };
			rd_addr3_r <= { ~counter[NUMSTAGES-3:NUMSTAGES-4], counter[NUMSTAGES-5:0] };
			wr_addr3_r <= { ~counter[NUMSTAGES-3:NUMSTAGES-4], counter[NUMSTAGES-5:0] };
		end
		STAGE3, STAGE4 : begin
			rd_addr2_r <= 0;
			wr_addr2_r <= ~counter;	
			rd_addr3_r <= 0;
			wr_addr3_r <= ~counter;
		end
	endcase
end

endmodule
