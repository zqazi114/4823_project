module mux_control(
	counter,
	stage_num,
	m0_s,
	m1_s,
	m2_s,
	m3_s,
);

// --------------- parameters -----------------------
parameter NUMSTAGES = 5;

// --------------- states -----------------------
parameter STAGE0 = 3'b000, STAGE1 = 3'b001, STAGE2 = 3'b010, STAGE3 = 3'b011, STAGE4 = 3'b100; 

// --------------- define inputs and outputs--------------------
input counter, stage_num;
output m0_s, m1_s, m2_s, m3_s;

// --------------- define port types -----------------------
wire [NUMSTAGES-3:0] counter;
wire [2:0] stage_num;
reg m0_s;
reg [1:0] m1_s; 
reg m2_s;
reg m3_s;

// --------------- code begins here -----------------------
always @(counter, stage_num)
begin
	m0_s <= 1'b0;
	m3_s <= 1'b0;
	case(stage_num)
		STAGE0 : begin
			m1_s <= 2'b11;
			m2_s <= 1'b0;
		end
		STAGE1 : begin
			if(counter[NUMSTAGES-3]%2 == 1) begin
				m1_s <= 2'b01;
				m2_s <= 1'b0;
			end else begin
				m1_s <= 2'b10;
				m2_s <= 1'b1;
			end
			if(counter[NUMSTAGES-3] == 0) begin
				m1_s <= 2'b00;
			end
		end
		STAGE2 : begin
			if(counter[NUMSTAGES-3:NUMSTAGES-4]%2 == 1) begin
				m1_s <= 2'b01;
				m2_s <= 1'b0;
			end else begin
				m1_s <= 2'b10;
				m2_s <= 1'b1;
			end
			if(counter[NUMSTAGES-3:NUMSTAGES-4] == 0) begin
				m1_s <= 2'b00;
			end
		end
		STAGE3 : begin
			m3_s <= 1'b1;
			if(counter[NUMSTAGES-3:NUMSTAGES-5]%2 == 1) begin
				m1_s <= 2'b01;
				m2_s <= 1'b0;
			end else begin
				m1_s <= 2'b10;
				m2_s <= 1'b1;
			end		
			if(counter[NUMSTAGES-3:NUMSTAGES-5] == 0) begin
				m1_s <= 2'b00;
			end
		end
		STAGE4 : begin
			m1_s <= 2'b00;
			m2_s <= 1'b1;
			m3_s <= 1'b1;
		end
		default : begin
			m0_s <= 1'bz;
			m1_s <= 2'bzz;
			m2_s <= 1'bz;
			m3_s <= 1'bz;
		end
	endcase
end

endmodule
