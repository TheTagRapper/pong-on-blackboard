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
    
    logic video_active_presync, hsync_presync, vsync_presync;

    
    dual_counter dc0 (.nReset(nReset) , .clk(clk) , .a_val(a_val), .b_val(b_val), .en(en), .A(hsync_presync), .B(vsync_presync));
    
    
    // Video Active Regions
    assign video_active_presync = (a_val < 1280) && (b_val < 720);    
    
    always_ff @(posedge clk or negedge nReset)
    begin
        if (!nReset) 
        begin
            px <= 0;
            py <= 0;
            hsync <= 1'b0;
            vsync <= 1'b0;
            video_active <= 1'b0;
        end
        else 
        begin
            hsync <= hsync_presync;
            vsync <= vsync_presync;
            video_active <= video_active_presync;
            if (video_active)
            	begin
            	 px <= a_val;
            	 py <= b_val;
            	end
            else
                begin
                    px <= 0;
                    py <= 0;
                end
        end
   end
    
endmodule
