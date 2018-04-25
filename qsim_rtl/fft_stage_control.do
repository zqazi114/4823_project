vsim work.fft
delete wave *
add wave clk
add wave en
add wave stage_num
add wave en_stage
add wave stage_done
add wave state
add wave m0_s
add wave m1_s
add wave m2_s
add wave m3_s
force -freeze sim/:fft:clk 1 0, 0 {50 ps} -r 100ps
force -deposit sim/:fft:en 1 0
force -deposit sim/:fft:en_stage 0 0
force -deposit sim/:fft:ld_data 1 0
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
run
run
run
run
run
run
force -deposit sim/:fft:ld_data 0 0
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
run
run
