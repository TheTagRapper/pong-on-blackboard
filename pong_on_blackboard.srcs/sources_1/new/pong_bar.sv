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
        input logic [11:0] px,
        input logic [11:0] py,
        input logic [11:0] sw,
        input logic display_clock,
        input logic [21:0] frame_divider,
        
        input logic nReset,
        
        output logic [11:0] bar_px, bar_py,

        output logic bar_on
    );
    
    
    
    
    logic [23:0] bg_color, box_color;
    logic [7:0] bar_width, bar_height;
    logic [3:0] SWITCH_NUMBER;
    
    
    assign bg_color = 24'h123456;
    assign box_color = 24'hFFFFFF;
    assign bar_width = 32;
    assign bar_height = 64;
    assign bar_px = (PLAYER == 0 ? (12'd16) : (12'd1232));
    assign SWITCH_NUMBER = (PLAYER == 0 ? (11) : (0));
    
    
   
    always_comb
    begin
        // Rendering Box
        if ( (px <= bar_px + bar_width) && (px >= bar_px) && (py <= bar_py + bar_height) && (py >= bar_py) ) {bar_on} <= {1'b1};
        else {bar_on} <= 1'b0; 
    
    end
    
    
    logic out_of_bounds;
    
    assign out_of_bounds = (((bar_py > 720 - bar_height) && (sw[SWITCH_NUMBER] == 0)) || ((bar_py < 3) && (sw[SWITCH_NUMBER] == 1)));
        
    // Controls how the speed works
    
    always_ff @(posedge display_clock or negedge nReset)
    begin
        // reset display
        if (~nReset) {bar_py} <= 12'd0;    
    
        else if ((frame_divider == 2504177)) begin
            // Moving pong box
            if (~out_of_bounds)
            begin
                if (sw[SWITCH_NUMBER])
                    begin
                        bar_py <= bar_py - 6;
                    end
                else
                    begin
                        bar_py <= bar_py + 6;                
                    end 
            end
         end
      end
endmodule
