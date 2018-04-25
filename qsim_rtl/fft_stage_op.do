vsim work.fft
delete wave *
add wave clk
add wave state
add wave ld_data
add wave ld_done
add wave en
add wave stage_done
add wave state
add wave done
force -freeze sim/:fft:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:fft:ld_data 1 0
run 1ns
force -deposit sim/:fft:ld_done 1 0
run 1ns
force -deposit sim/:fft:en 1 0
run 1ns
run 1ns
run 1ns
run 1ns
run 1ns
