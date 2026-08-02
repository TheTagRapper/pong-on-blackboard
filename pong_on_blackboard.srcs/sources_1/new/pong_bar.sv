`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2026 02:00:43 PM
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


module pong_bar #(parameter PLAYER = 0) (
        input logic [9:0] px, py,
        input logic [11:0] sw,
        input logic display_clock,
        input logic nReset,
        output logic [7:0] red, green, blue,
        output logic box_on
    );
    
    
    
    
        logic [9:0] box_px, box_py; // Does top left
    logic [23:0] bg_color, box_color;
    logic [7:0] box_width, box_height;
    logic [3:0] SWITCH_NUMBER;
    
    
    assign bg_color = 24'h000000;
    assign box_color = 24'hFFFFFF;
    assign box_width = 32;
    assign box_height = 64;
    assign box_px = (PLAYER == 0 ? (16) : (592));
    assign SWITCH_NUMBER = (PLAYER == 0 ? (11) : (0));
    
    
   
    always_comb
    begin
        // Rendering Box
        if ( (px < box_px + box_width) && (px >= box_px) && (py <= box_py + box_height) && (py >= box_py) ) {red, green, blue, box_on} = {box_color, 1'b1};
        else {red, green, blue} = bg_color; 
    
    end
    
    
    logic out_of_bounds;
    
    assign out_of_bounds = (((box_py > 480 - box_height) && (sw[SWITCH_NUMBER] == 0)) || ((box_py == 0) && (sw[SWITCH_NUMBER] == 1)));
        
    // Controls how the speed works
    logic [21:0] frame_divider;
    
    always_ff @(posedge display_clock or negedge nReset)
    begin
        // reset display
        if (~nReset) {box_px, box_py, frame_divider} <= 1;    
    
        else if ((frame_divider == 250000)) begin
            frame_divider <= 0;   
            
            // Moving pong box
            if (~out_of_bounds)
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
     
        else frame_divider <= frame_divider + 1;
    end
endmodule
