transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+pong_box_tb  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.pong_box_tb xil_defaultlib.glbl

do {pong_box_tb.udo}

run 1000ns

endsim

quit -force
