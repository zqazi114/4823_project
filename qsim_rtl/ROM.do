vsim work.ROM
delete wave *
add wave -radix decimal sim/:ROM:D 
add wave -radix decimal sim/:ROM:addr 
add wave -radix decimal sim/:ROM:Q
add wave sim/:ROM:EN
add wave sim/:ROM:WR
add wave sim/:ROM:RESET
add wave sim/:ROM:CLK

force -freeze sim/:ROM:CLK 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:ROM:EN 0 0
force -deposit sim/:ROM:WR 0 0
force -deposit sim/:ROM:RESET 0 0
run
force -deposit sim/:ROM:addr 0000000000000001 0
force -deposit sim/:ROM:D 0000000000000011 0
force -deposit sim/:ROM:WR 1 0
force -deposit sim/:ROM:EN 1 0
run
force -deposit sim/:ROM:WR 0 0
run
force -deposit sim/:ROM:WR 1 0
force -deposit sim/:ROM:addr 0000000000000111 0
force -deposit sim/:ROM:D 0000100000000011 0
run
force -deposit sim/:ROM:WR 0 0
run
force -deposit sim/:ROM:EN 0 0
force -deposit sim/:ROM:WR 1 0
force -deposit sim/:ROM:D 0000100100000011 0
run
force -deposit sim/:ROM:RESET 0 0
run
force -deposit sim/:ROM:addr 0000000000000001 0
force -deposit sim/:ROM:D 0000000000000011 0
force -deposit sim/:ROM:WR 1 0
force -deposit sim/:ROM:EN 1 0
run
force -deposit sim/:ROM:WR 0 0
run
