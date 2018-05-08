module mux_control(
	ld_data,
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
parameter	STAGE0 = 3'b000, 
			STAGE1 = 3'b001, 
			STAGE2 = 3'b010, 
			STAGE3 = 3'b011, 
			STAGE4 = 3'b100,
			STAGE5 = 3'b101,
			STAGE6 = 3'b110,
			STAGE7 = 3'b111;

// --------------- define inputs and outputs--------------------
input ld_data, counter, stage_num;
output m0_s, m1_s, m2_s, m3_s;

// --------------- define port types -----------------------
wire ld_data;
wire [NUMSTAGES-3:0] counter;
wire [2:0] stage_num;
reg m0_s;
reg [1:0] m1_s; 
reg m2_s;
reg m3_s;

// --------------- code begins here -----------------------
always @(ld_data, counter, stage_num)
begin
	if(ld_data)
		m0_s <= 1'b0;
	else 
	begin
		m0_s <= 1'b1;
		m3_s <= 1'b0;
	case(stage_num)
		STAGE0 : begin
			m1_s <= 2'b10;
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
			m3_s <= 1'b1;
			if(counter[NUMSTAGES-3:NUMSTAGES-6]%2 == 1) begin
				m1_s <= 2'b01;
				m2_s <= 1'b0;
			end else begin
				m1_s <= 2'b10;
				m2_s <= 1'b1;
			end		
			if(counter[NUMSTAGES-3:NUMSTAGES-6] == 0) begin
				m1_s <= 2'b00;
			end
		end
		STAGE5 : begin
			m3_s <= 1'b1;
			if(counter[NUMSTAGES-3:NUMSTAGES-7]%2 == 1) begin
				m1_s <= 2'b01;
				m2_s <= 1'b0;
			end else begin
				m1_s <= 2'b10;
				m2_s <= 1'b1;
			end		
			if(counter[NUMSTAGES-3:NUMSTAGES-7] == 0) begin
				m1_s <= 2'b00;
			end
		end
		STAGE6 : begin
			m3_s <= 1'b1;
			if(counter[NUMSTAGES-3:NUMSTAGES-8]%2 == 1) begin
				m1_s <= 2'b01;
				m2_s <= 1'b0;
			end else begin
				m1_s <= 2'b10;
				m2_s <= 1'b1;
			end		
			if(counter[NUMSTAGES-3:NUMSTAGES-8] == 0) begin
				m1_s <= 2'b00;
			end
		end
		STAGE7 : begin
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
end

endmodule
