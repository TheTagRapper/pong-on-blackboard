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
        output logic [11:0] px, py
    );
    
    (* mark_debug = "true", keep = "true" *) 
    logic [11:0] a_val, b_val;
    logic en;
    
    assign en = 1'b1;
    
    
    dual_counter dc0 (.nReset(nReset) , .clk(clk) , .a_val(a_val), .b_val(b_val), .en(en), .A(hsync), .B(vsync));
    
    
    // Video Active Regions
    assign video_active = (a_val >= 88) && (a_val < 2008) && (b_val >= 4) && (b_val < 10);    
    
    always_ff @(posedge clk or negedge nReset)
    begin
        if (!nReset) 
        begin
            px <= 0;
            py <= 0;
        end
        else 
        begin
            if (video_active)
            	begin
            	 px <= a_val - 81;
            	 py <= b_val - 3;
            	end
        end
   end
    
endmodule
