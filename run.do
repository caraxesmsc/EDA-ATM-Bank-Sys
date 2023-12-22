vlib work
vlog ATMmodule.v ATMmoduleTB.sv +cover
vsim -voptargs=+acc work.ATMmoduleTB -cover
add wave *
coverage save ATMmoduleTB.ucbd -onexit -du ATMmodule
run -all