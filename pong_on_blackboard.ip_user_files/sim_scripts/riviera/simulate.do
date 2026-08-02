transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+display_controller  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.display_controller xil_defaultlib.glbl

do {display_controller.udo}

run 1000ns

endsim

quit -force
