`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 07:23:24 PM
// Design Name: 
// Module Name: pong_box_tb
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


module pong_box_tb;

logic [9:0] px, py;
logic [11:0] sw;
logic display_clock;
logic nReset;
logic [21:0] frame_divider;
logic [9:0] p1_px, p1_py, p2_px, p2_py;

logic p1_scored, p2_scored;
logic box_on;

pong_box pb0 (.*);

always #5ns display_clock <= ~display_clock;

always #100ps py <= py + 1;

initial begin
    px = 0;
    py = 0;
    sw = 12'h801;
    display_clock = 0;
    nReset = 1;
    frame_divider = 250000;
    p1_px = 16;
    p1_py = 0;
    p2_px = 592;
    p2_py = 0;
    
    #1ps nReset = 0;
    #1ps nReset = 1;

end

endmodule
