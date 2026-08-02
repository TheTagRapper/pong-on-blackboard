`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2026 04:09:36 PM
// Design Name: 
// Module Name: pong_box
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


module pong_box(
        input logic [9:0] px, py,
        input logic [11:0] sw,
        input logic display_clock,
        input logic nReset,
        input logic [21:0] frame_divider,
        
        input logic [9:0] p1_px, p1_py, p2_px, p2_py,
        
        output logic [7:0] red, green, blue,
        output logic p1_scored, p2_scored,
        output logic bar_on
    );
    
    logic [9:0] box_px, box_py; // Does top left
    logic [7:0] box_width, box_height;
    logic [3:0] SWITCH_NUMBER;
    
    
    assign {red, green, blue} = 24'hFFFFFF;
    assign box_width = 16;
    assign box_height = 16;
    
    
   
    always_comb
    begin
        // Rendering Box
        if ( (px < box_px + box_width) && (px >= box_px) && (py <= box_py + box_height) && (py >= box_py) ) bar_on = 1'b1;    
    end
    
    
    logic wall_collision, p1_collision, p2_collision;
    
    assign wall_collision = (((box_py > 480 - box_height)  || ((box_py == 0))));
    assign p1_collision = ((box_px < p1_px + 32) && (box_py < p1_py + 64));
    assign p2_collision = ((box_px < p1_px + 32) && (box_py < p1_py + 64));
    
    assign p1_scored = ((box_px >
    // Controls how the speed works
    
    always_ff @(posedge display_clock or negedge nReset)
    begin
        // reset display
        if (~nReset) {box_px, box_py} <= 1;    
    
        else if ((frame_divider == 250000)) begin
            // Moving pong box
            if (~wall_collision)
            begin
                if (sw[SWITCH_NUMBER])
                    begin
                        box_py <= box_py - 1;
                    end
                else
                    begin
                        box_py <= box_py + 1;                
                    end 
            end
         end
      end
    
    
endmodule
