transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../../../../../media/pyra/88d368f5-2c7d-43f4-90cd-458b64c9c5111/Vivado/2025.2/data/rsb/busdef" "+incdir+../../../pong_on_blackboard.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"/media/pyra/88d368f5-2c7d-43f4-90cd-458b64c9c5111/Vivado/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  -incr \
"/media/pyra/88d368f5-2c7d-43f4-90cd-458b64c9c5111/Vivado/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../../../media/pyra/88d368f5-2c7d-43f4-90cd-458b64c9c5111/Vivado/2025.2/data/rsb/busdef" "+incdir+../../../pong_on_blackboard.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"../../../pong_on_blackboard.gen/sources_1/ip/hdmi_tx_0/hdl/encode.v" \
"../../../pong_on_blackboard.gen/sources_1/ip/hdmi_tx_0/hdl/serdes_10_to_1.v" \
"../../../pong_on_blackboard.gen/sources_1/ip/hdmi_tx_0/hdl/srldelay.v" \
"../../../pong_on_blackboard.gen/sources_1/ip/hdmi_tx_0/hdl/hdmi_tx_v1_0.v" \
"../../../pong_on_blackboard.gen/sources_1/ip/hdmi_tx_0/sim/hdmi_tx_0.v" \
"../../../pong_on_blackboard.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../pong_on_blackboard.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../../../../../media/pyra/88d368f5-2c7d-43f4-90cd-458b64c9c5111/Vivado/2025.2/data/rsb/busdef" "+incdir+../../../pong_on_blackboard.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"../../../pong_on_blackboard.srcs/sources_1/imports/new/bin_counter.sv" \
"../../../pong_on_blackboard.srcs/sources_1/imports/new/dual_counter.sv" \
"../../../pong_on_blackboard.srcs/sources_1/imports/new/vga_controller.sv" \
"../../../pong_on_blackboard.srcs/sources_1/imports/new/display_controller.sv" \

vlog -work xil_defaultlib \
"glbl.v"

