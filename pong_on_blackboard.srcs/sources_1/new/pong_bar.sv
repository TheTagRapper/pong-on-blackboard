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
        input logic [21:0] frame_divider,
        
        input logic nReset,
        output logic [9:0] bar_px, bar_py,

        output logic bar_on
    );
    
    
    
    
    logic [23:0] bg_color, box_color;
    logic [7:0] box_width, box_height;
    logic [3:0] SWITCH_NUMBER;
    
    
    assign bg_color = 24'h123456;
    assign box_color = 24'hFFFFFF;
    assign bar_width = 32;
    assign bar_height = 64;
    assign box_px = (PLAYER == 0 ? (16) : (592));
    assign SWITCH_NUMBER = (PLAYER == 0 ? (11) : (0));
    
    
   
    always_comb
    begin
        // Rendering Box
        if ( (px < bar_px + bar_width) && (px >= bar_px) && (py <= bar_py + bar_height) && (py >= bar_py) ) {bar_on} = {1'b1};
        else {bar_on} = 1'b0; 
    
    end
    
    
    logic out_of_bounds;
    
    assign out_of_bounds = (((bar_py > 480 - bar_height) && (sw[SWITCH_NUMBER] == 0)) || ((bar_py == 0) && (sw[SWITCH_NUMBER] == 1)));
        
    // Controls how the speed works
    
    always_ff @(posedge display_clock or negedge nReset)
    begin
        // reset display
        if (~nReset) {bar_py} <= 10'd0;    
    
        else if ((frame_divider == 250000)) begin
            // Moving pong box
            if (~out_of_bounds)
            begin
                if (sw[SWITCH_NUMBER])
                    begin
                        bar_py <= bar_py - 1;
                    end
                else
                    begin
                        bar_py <= bar_py + 1;                
                    end 
            end
         end
      end
endmodule
