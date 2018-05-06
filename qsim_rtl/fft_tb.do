# //  Questa Sim-64
# //  Version 10.3d linux_x86_64 Oct  6 2014
# //
# //  Copyright 1991-2014 Mentor Graphics Corporation
# //  All Rights Reserved.
# //
# //  THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# //  WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS
# //  LICENSORS AND IS SUBJECT TO LICENSE TERMS.
# //
vsim work.fft_tb
# vsim 
# Start time: 22:17:45 on May 05,2018
# ** Warning: (vsim-8891) All optimizations are turned off because the -novopt switch is in effect. This will cause your simulation to run very slowly. If you are using this switch to preserve visibility for Debug or PLI features please see the User's Manual section on Preserving Object Visibility with vopt.
# Loading work.fft_tb
# Loading work.read_input
# Loading work.fft
# Loading work.twiddle
# Loading work.rom
# Loading work.ram
# Loading work.pe
# Loading work.qadd
# Loading work.qmult
# Loading work.fft_stage_control
# Loading work.address_control
# Loading work.mux_control
# ** Warning: (vsim-3017) ../rtl32/fft.v(129): [TFMPC] - Too few port connections. Expected 10, found 9.
#         Region: :fft_tb:fft0:pe0
# ** Warning: (vsim-3722) ../rtl32/fft.v(129): [TFMPC] - Missing connection for port 'out3'.
# ** Warning: (vsim-3017) ../rtl32/fft_stage_control.v(80): [TFMPC] - Too few port connections. Expected 8, found 7.
#         Region: :fft_tb:fft0:control0:mux_ctrl
view wave
# .main_pane.wave.interior.cs.body.pw.wf
add wave *
add wave -position insertpoint  \
sim/:fft_tb:fft0:bank0_in \
sim/:fft_tb:fft0:bank0_out \
sim/:fft_tb:fft0:cs \
sim/:fft_tb:fft0:data_in0 \
sim/:fft_tb:fft0:data_out0 \
sim/:fft_tb:fft0:en_stage \
sim/:fft_tb:fft0:m0_s \
sim/:fft_tb:fft0:m1_s \
sim/:fft_tb:fft0:m21_out \
sim/:fft_tb:fft0:m2_s \
sim/:fft_tb:fft0:out_addr \
sim/:fft_tb:fft0:pe_in0 \
sim/:fft_tb:fft0:pe_in1 \
sim/:fft_tb:fft0:pe_out0 \
sim/:fft_tb:fft0:rd_addr0_r \
sim/:fft_tb:fft0:rd_en \
sim/:fft_tb:fft0:state \
sim/:fft_tb:fft0:wr_en
