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
        input logic [11:0] px, py,
        input logic [11:0] sw,
        input logic display_clock,
        input logic nReset,
        input logic [21:0] frame_divider,
        
        input logic [11:0] p1_px, p2_px,
        
        input logic [11:0] p1_py, p2_py,
        
        output logic p1_scored, p2_scored,
        output logic box_on
    );
    
    (* mark_debug = "true", keep = "true" *)
    logic [11:0] box_px, box_py; // Does top left
    logic [7:0] box_width, box_height;
    logic [3:0] SWITCH_NUMBER;
    
    
    assign box_color = 24'hFFFFFF;
    assign bg_color = 24'h123456;

    assign box_width = 16;
    assign box_height = 16;
    
    
   
    always_comb
    begin
        // Rendering Box
        if ( (px <= box_px + box_width) && (px >= box_px) && (py <= box_py + box_height) && (py >= box_py) ) {box_on} = {1'b1};    
        else {box_on} = {1'b0};
    end
    
    (* mark_debug = "true", keep = "true" *)
    logic hor_wall_collision;
    
    (* mark_debug = "true", keep = "true" *)
    logic ver_wall_collision;
    
    (* mark_debug = "true", keep = "true" *)

    logic p1_collision, p2_collision;
    
    
    assign hor_wall_collision = (((box_py >= 704)  || ((box_py == 0))));
    assign ver_wall_collision = ((box_px >= 1264 ) || (box_px == 0));
    assign p1_collision = ((box_px <= p1_px + 32)  && (box_py <= p1_py + 64) && (box_py >= p1_py) ) ;
    assign p2_collision = ((box_px >= p2_px - 16) && (box_py <= p2_py + 64) && (box_py >= p2_py) );
    
    assign p1_scored = p1_collision;
    assign p2_scored = p2_collision;
    
    // Controls how the speed works
    (* mark_debug = "true", keep = "true" *)
    logic [11:0] dx, dy;
        

    
    always_ff @(posedge display_clock or negedge nReset)
    begin
        // reset display
        if (~nReset) {box_px, box_py, dx, dy} <= {12'd640, 12'd360, 12'd3, 12'd4};  
        else 
            begin  
            if ((frame_divider == 2504177))
                begin
                    if (hor_wall_collision) 
                        begin 
                            box_py <= box_py - dy; // This to avoid the box getting trapped at the bottom
                            dy <= -dy;
                        end
                    else if (ver_wall_collision || p1_collision || p2_collision) 
                       begin
                        box_px <= box_px - dx; // This to avoid the box getting trapped at the sides 
                        dx <= -dx;
                      end
                    else
                        begin
                        // Non Blocking so relies on old dx/dy must separate out
                            box_py <= box_py + dy;
                            box_px <= box_px + dx;                            
                        end
                end
            end
    end
      
      
      
      

  
    
endmodule
