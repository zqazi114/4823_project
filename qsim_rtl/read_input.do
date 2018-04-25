vsim work.read_input
delete wave *
add wave clk
add wave s
add wave samples
add wave done
add wave -radix decimal sim/:read_input:i
add wave -radix unsigned sim/:read_input:state
add wave -radix unsigned sim/:read_input:next_state
add wave -radix hexadecimal sim/:read_input:data_out0
add wave -radix hexadecimal sim/:read_input:data_out1
add wave -radix hexadecimal sim/:read_input:data_out2
add wave -radix hexadecimal sim/:read_input:data_out3
force -freeze sim/:read_input:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:read_input:s 0 0
run
run
force -deposit sim/:read_input:s 1 0
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
force -deposit sim/:read_input:s 0 0
run
force -deposit sim/:read_input:s 1 0
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
