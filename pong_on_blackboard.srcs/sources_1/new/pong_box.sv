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
        
        output logic p1_scored, p2_scored,
        output logic box_on
    );
    
    logic [9:0] box_px, box_py; // Does top left
    logic [7:0] box_width, box_height;
    logic [3:0] SWITCH_NUMBER;
    
    
    assign box_color = 24'hFFFFFF;
    assign bg_color = 24'h123456;

    assign box_width = 16;
    assign box_height = 16;
    
    
   
    always_comb
    begin
        // Rendering Box
        if ( (px < box_px + box_width) && (px >= box_px) && (py <= box_py + box_height) && (py >= box_py) ) {box_on} = {1'b1};    
        else {box_on} = {1'b0};
    end
    
    
    logic horizontal_wall_collision, p1_collision, p2_collision;
    
    assign wall_collision = (((box_py > 480 - box_height)  || ((box_py == 0))));
    assign p1_collision = ((box_px < p1_px + 32) && (box_py < p1_py + 64));
    assign p2_collision = ((box_px < p1_px + 32) && (box_py < p1_py + 64));
    
    assign p1_scored = p1_collision;
    assign p2_scored = p2_collision;
    
    // Controls how the speed works
    logic [9:0] dx, dy;
    
    
    always_ff @(posedge display_clock or negedge nReset)
    begin
        // reset display
        if (~nReset) {box_px, box_py, dx, dy} <= {10'd320, 10'd240, 10'd1, 10'd1};    
    
        else if ((frame_divider == 250000)) begin
            
            // Letting it bounce
            if (wall_collision) dy <= ~dy + 1;
            if (p1_collision || p2_collision) dx <= ~dy + 1;
            
            // Moving pong box
            if (!wall_collision && !p1_collision && !p2_collision)
            begin
                box_py <= box_py + dx;
                box_py <= box_py + dy;                

            end
            
         end
      end
    
    
endmodule
