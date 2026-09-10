`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 06:22:08 PM
// Design Name: 
// Module Name: pong_bar_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pong_bar_tb;

logic [9:0] px, py;
logic [11:0] sw;
logic display_clock;
logic [21:0] frame_divider;
logic nReset;

logic [9:0] bar_px, bar_py;
logic bar_on;

pong_bar #(.PLAYER(0)) pb0 (.*);


always #5ns display_clock <= ~display_clock;

initial begin
px = 16;
py = 1;
sw = 12'h801;
display_clock = 0;
frame_divider = 250000;
nReset = 1;

#2ns nReset = 0;
#3ns nReset = 1;


end

endmodule
