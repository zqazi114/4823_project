vsim work.ram
delete wave *
add wave clk
add wave rd_en
add wave wr_en
add wave cs
add wave -radix hexadecimal read_addr
add wave -radix hexadecimal write_addr
add wave -radix hexadecimal data_in
add wave -radix hexadecimal data_out
add wave -radix hexadecimal memory
force -freeze sim/:ram:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:ram:rd_en 0 0
force -deposit sim/:ram:wr_en 0 0
force -deposit sim/:ram:cs 0 0
run 1ns
