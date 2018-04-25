vsim work.fft
delete wave *
add wave clk
add wave en
add wave ld_data
add wave -radix hexadecimal data_in0
add wave -radix hexadecimal data_in1
add wave -radix hexadecimal data_in2
add wave -radix hexadecimal data_in3
add wave -radix hexadecimal data_out0
add wave -radix hexadecimal data_out1
add wave -radix hexadecimal data_out2
add wave -radix hexadecimal data_out3
add wave -radix hexadecimal rd_addr0
add wave -radix hexadecimal wr_addr0
add wave cs0
add wave rd_en0
add wave wr_en0
force -freeze sim/:fft:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:fft:en 0 0
force -deposit sim/:fft:ld_data 0 0
force -deposit sim/:fft:data_in0 0000000000000110 0
force -deposit sim/:fft:data_in1 0000000000000110 0
force -deposit sim/:fft:data_in2 0000000000000110 0
force -deposit sim/:fft:data_in3 0000000000000110 0
run 5ns
force -deposit sim/:fft:ld_data 1 0
run 5ns
run 5ns
