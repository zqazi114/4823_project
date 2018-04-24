module mux_controls(
	counter,
	stage_num,
	m0_s,
	m11_s,
	m12_s,
	m13_s,
	m14_s,
	m21_s,
	m22_s,
	m23_s,
	m24_s,
	m31_s,
	m32_s
);

input counter, stage_num;
output m0_s, m11_s, m12_s, m13_s, m14_s, m21_s, m22_s, m23_s, m24_s, m31_s, m32_s;

wire [5:0] counter;
wire [2:0] stage_num;
reg m0_s;
reg [1:0] m11_s, m12_s, m13_s, m14_s; 
reg m21_s, m22_s, m23_s, m24_s;
reg m31_s, m32_s;

always @(counter, stage_num)
begin
	m0_s <= 1'b0;
	m31_s <= 1'b0;
	m32_s <= 1'b0;

	case(stage_num)
		3'b000 : begin
			m11_s <= 2'b00;
			m12_s <= 2'b00;
			m13_s <= 2'b00;
			m14_s <= 2'b00;
			m21_s <= 1'b0;
			m22_s <= 1'b0;
			m23_s <= 1'b0;
			m24_s <= 1'b0;
		end
		3'b001 : begin
			if(counter[5] == 0) begin
				m11_s <= 2'b00;
				m12_s <= 2'b00;
				m13_s <= 2'b00;
				m14_s <= 2'b00;
			end
			if(counter[5] %2 == 1) begin
				m11_s <= 2'b01;
				m12_s <= 2'b01;
				m13_s <= 2'b01;
				m14_s <= 2'b01;
				m21_s <= 1'b1;
				m22_s <= 1'b1;
				m23_s <= 1'b1;
				m24_s <= 1'b1;
			end else begin
				m11_s <= 2'b00;
				m12_s <= 2'b00;
				m13_s <= 2'b00;
				m14_s <= 2'b00;
				m21_s <= 1'b0;
				m22_s <= 1'b0;
				m23_s <= 1'b0;
				m24_s <= 1'b0;
			end
		end
		3'b010, 3'b011, 3'b100, 3'b101, 3'b110 : begin
			if(counter[5] == 0) begin
				m11_s <= 2'b00;
				m12_s <= 2'b00;
				m13_s <= 2'b00;
				m14_s <= 2'b00;
			end
			if(counter[5] %2 == 1) begin
				m11_s <= 2'b01;
				m12_s <= 2'b01;
				m13_s <= 2'b01;
				m14_s <= 2'b01;
				m21_s <= 1'b1;
				m22_s <= 1'b1;
				m23_s <= 1'b1;
				m24_s <= 1'b1;
			end else begin
				m11_s <= 2'b10;
				m12_s <= 2'b10;
				m13_s <= 2'b10;
				m14_s <= 2'b10;
				m21_s <= 1'b0;
				m22_s <= 1'b0;
				m23_s <= 1'b0;
				m24_s <= 1'b0;
			end		
		end
		3'b110 : begin
			m31_s <= 1'b1;
			m31_s <= 1'b1;
			if(counter[5] == 0) begin
				m11_s <= 2'b00;
				m12_s <= 2'b00;
				m13_s <= 2'b00;
				m14_s <= 2'b00;
			end
			if(counter[5] %2 == 1) begin
				m11_s <= 2'b01;
				m12_s <= 2'b01;
				m13_s <= 2'b01;
				m14_s <= 2'b01;
				m21_s <= 1'b1;
				m22_s <= 1'b1;
				m23_s <= 1'b1;
				m24_s <= 1'b1;
			end else begin
				m11_s <= 2'b10;
				m12_s <= 2'b10;
				m13_s <= 2'b10;
				m14_s <= 2'b10;
				m21_s <= 1'b0;
				m22_s <= 1'b0;
				m23_s <= 1'b0;
				m24_s <= 1'b0;
			end		
		end
		3'b111 : begin
			m11_s <= 2'b00;
			m12_s <= 2'b00;
			m13_s <= 2'b00;
			m14_s <= 2'b00;
			m21_s <= 1'b0;
			m22_s <= 1'b0;
			m23_s <= 1'b0;
			m24_s <= 1'b0;
			m31_s <= 1'b1;
			m32_s <= 1'b1;
		end
	endcase
end

endmodule
