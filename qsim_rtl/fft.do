vsim work.fft
delete wave *
add wave clk
add wave en
add wave ld_data
add wave ld_done
add wave output_data
add wave -radix hexadecimal data_in0
add wave -radix hexadecimal data_in1
add wave -radix hexadecimal data_in2
add wave -radix hexadecimal data_in3
add wave -radix hexadecimal data_out0
add wave -radix hexadecimal data_out1
add wave -radix hexadecimal data_out2
add wave -radix hexadecimal data_out3
add wave -radix hexadecimal bank0_in
add wave -radix hexadecimal bank0_out
add wave -radix hexadecimal pe_in0
add wave -radix hexadecimal pe_out0
add wave -radix hexadecimal m21_out
add wave -radix hexadecimal rd_addr0
add wave -radix hexadecimal rd_addr0_r
add wave -radix hexadecimal rd_addr1_r
add wave -radix hexadecimal rd_addr2_r
add wave -radix hexadecimal rd_addr3_r
add wave -radix hexadecimal wr_addr0_r
add wave -radix hexadecimal wr_addr1_r
add wave -radix hexadecimal wr_addr2_r
add wave -radix hexadecimal wr_addr3_r
add wave rd_en0
add wave wr_en0
add wave cs0
add wave stage_num
add wave en_stage
add wave stage_done
add wave -radix unsigned state
add wave m0_s
add wave m1_s
add wave m2_s
add wave m3_s
force -freeze sim/:fft:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:fft:output_data 0 0
force -deposit sim/:fft:data_in0 1111000011110000 0
force -deposit sim/:fft:en 1 0
force -deposit sim/:fft:en_stage 0 0
force -deposit sim/:fft:ld_data 1 0
run 1ns
force -deposit sim/:fft:ld_done 1 0
run 10ns
force -deposit sim/:fft:output_data 0 0
run 1ns
force -deposit sim/:fft:output_data 1 0
run 5ns
