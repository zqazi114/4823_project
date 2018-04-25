vsim work.fft_tb
delete wave *
add wave sim/:fft_tb:clk
add wave sim/:fft_tb:clk
add wave sim/:fft_tb:ld_data_r
add wave sim/:fft_tb:ld_done
add wave sim/:fft_tb:en_r
add wave sim/:fft_tb:done
add wave sim/:fft_tb:state
add wave -radix hexadecimal sim/:fft_tb:fft_in0
add wave -radix hexadecimal sim/:fft_tb:fft_in1
add wave -radix hexadecimal sim/:fft_tb:fft_in2
add wave -radix hexadecimal sim/:fft_tb:fft_in3
add wave -radix hexadecimal sim/:fft_tb:fft_out0
add wave -radix hexadecimal sim/:fft_tb:fft_out1
add wave -radix hexadecimal sim/:fft_tb:fft_out2
add wave -radix hexadecimal sim/:fft_tb:fft_out3
run 500ps
run 15ns
