vsim work.mux_control
delete wave *
add wave -radix unsigned sim/:mux_control:counter
add wave -radix unsigned sim/:mux_control:stage_num
add wave sim/:mux_control:m0_s
add wave sim/:mux_control:m1_s
add wave sim/:mux_control:m2_s
add wave sim/:mux_control:m3_s

force -deposit sim/:mux_control:stage_num 000 0
force -deposit sim/:mux_control:counter 000 0
run
force -deposit sim/:mux_control:counter 111 0
run
force -deposit sim/:mux_control:counter 110 0
run

force -deposit sim/:mux_control:stage_num 001 0
force -deposit sim/:mux_control:counter 000 0
run
force -deposit sim/:mux_control:counter 100 0
run
force -deposit sim/:mux_control:counter 010 0
run

force -deposit sim/:mux_control:stage_num 010 0
force -deposit sim/:mux_control:counter 000 0
run
force -deposit sim/:mux_control:counter 110 0
run
force -deposit sim/:mux_control:counter 100 0
run

force -deposit sim/:mux_control:stage_num 011 0
force -deposit sim/:mux_control:counter 000 0
run
force -deposit sim/:mux_control:counter 111 0
run
force -deposit sim/:mux_control:counter 110 0
run

force -deposit sim/:mux_control:stage_num 100 0
force -deposit sim/:mux_control:counter 000 0
run
force -deposit sim/:mux_control:counter 111 0
run
force -deposit sim/:mux_control:counter 110 0
run

