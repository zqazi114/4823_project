vsim work.fft

delete wave *
add wave clk
add wave -radix hexadecimal sim/:fft_stage:ld_data
add wave init_error
add wave ld_done_r
add wave -radix hexadecimal sim/:fft_stage:bank0_in
add wave -radix hexadecimal sim/:fft_stage:bank1_in
add wave -radix hexadecimal sim/:fft_stage:bank2_in
add wave -radix hexadecimal sim/:fft_stage:bank3_in
force -freeze sim/:fft_stage:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:fft_stage:ld_data 0 0
run
run
force -deposit sim/:fft_stage:ld_data 1 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
force -deposit sim/:fft_stage:ld_data 0 0
run
run
force -deposit sim/:fft_stage:ld_data 1 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
