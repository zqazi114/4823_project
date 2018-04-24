vsim work.FP_MUL

delete wave *
add wave sim/:FP_MUL:A
add wave sim/:FP_MUL:B
add wave sim/:FP_MUL:C
add wave sim/:FP_MUL:O
add wave sim/:FP_MUL:c
add wave sim/:FP_MUL:temp
force -deposit sim/:FP_MUL:A 10100000 0
force -deposit sim/:FP_MUL:B 10100000 0
run 10 ps
force -deposit sim/:FP_MUL:A 10100000 0
force -deposit sim/:FP_MUL:B 00100000 0
run 10 ps
force -deposit sim/:FP_MUL:A 01000000 0
force -deposit sim/:FP_MUL:B 00011000 0
run 10 ps
force -deposit sim/:FP_MUL:A 00010000 0
force -deposit sim/:FP_MUL:B 00001000 0
run 10 ps
force -deposit sim/:FP_MUL:A 10100000 0
force -deposit sim/:FP_MUL:B 00100000 0
run 10 ps
force -deposit sim/:FP_MUL:A 10100000 0
force -deposit sim/:FP_MUL:B 10100000 0
run 10 ps
force -deposit sim/:FP_MUL:A 01000000 0
force -deposit sim/:FP_MUL:B 01000000 0
run 10 ps
