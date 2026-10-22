onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /d4_pwm_tb/clk
add wave -noupdate /d4_pwm_tb/rstn
add wave -noupdate /d4_pwm_tb/pwm_out
add wave -noupdate -expand /d4_pwm_tb/duty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3107202 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {7108500 ps}
