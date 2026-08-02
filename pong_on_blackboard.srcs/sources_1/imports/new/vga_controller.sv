`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2026 02:06:20 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
        input logic clk, nReset,
        output logic hsync, vsync, video_active,
        output logic [9:0] px, py
    );
    
    logic [9:0] a_val, b_val;
    logic en;
    
    assign en = 1'b1;
    
    
    dual_counter dc0 (.nReset(nReset) , .clk(clk) , .a_val(a_val), .b_val(b_val), .en(en), .A(hsync), .B(vsync));

    assign video_active = (a_val > 15) && (a_val < 656) && (b_val > 9) && (b_val < 490);    
    
    always_ff @(posedge clk)
    begin
        if ((a_val > 15) && (a_val < 656)) px <= a_val - 15;
        if ((b_val > 9) && (b_val < 490)) py <= b_val - 9;
    end
    
endmodule
