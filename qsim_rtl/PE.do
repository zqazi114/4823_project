vsim work.PE
delete wave *
add wave -radix decimal sim/:PE:in0
add wave -radix decimal sim/:PE:in1
add wave -radix decimal sim/:PE:in2
add wave -radix decimal sim/:PE:in3
add wave -radix decimal sim/:PE:twiddle
add wave -radix decimal sim/:PE:out0
add wave -radix decimal sim/:PE:out1
add wave -radix decimal sim/:PE:out2
add wave -radix decimal sim/:PE:out3
add wave -radix decimal sim/:PE:in1_neg
add wave -radix decimal sim/:PE:in3_neg
add wave -radix decimal sim/:PE:out20
add wave -radix decimal sim/:PE:out30

force -deposit sim/:PE:in0 0000000000000001
force -deposit sim/:PE:in1 0000000000000001
force -deposit sim/:PE:in2 0000000000000001
force -deposit sim/:PE:in3 0000000000000001
force -deposit sim/:PE:twiddle 0000000000000010
run
force -deposit sim/:PE:in0 0000000000000001
force -deposit sim/:PE:in1 1000000000000001
force -deposit sim/:PE:in2 0000000000000001
force -deposit sim/:PE:in3 1000000000000001
force -deposit sim/:PE:twiddle 0000000000000010
run
force -deposit sim/:PE:in0 0000000000001001
force -deposit sim/:PE:in1 0000000000001001
force -deposit sim/:PE:in2 0000000000001001
force -deposit sim/:PE:in3 0000000000001001
force -deposit sim/:PE:twiddle 0000000000000010
run
force -deposit sim/:PE:in0 0001000000000001
force -deposit sim/:PE:in1 0000001110000001
force -deposit sim/:PE:in2 0111000000000001
force -deposit sim/:PE:in3 1111000000000001
force -deposit sim/:PE:twiddle 0000000000000010
run
force -deposit sim/:PE:in0 0000000000000001
force -deposit sim/:PE:in1 0000000000000001
force -deposit sim/:PE:in2 0000000000000001
force -deposit sim/:PE:in3 0000000000000001
force -deposit sim/:PE:twiddle 000100000000000
run
