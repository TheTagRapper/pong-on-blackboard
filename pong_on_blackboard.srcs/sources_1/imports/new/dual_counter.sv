`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 02:46:45 PM
// Design Name: 
// Module Name: dual_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Part of Real Digital Project 1 VGA Step 1
// 
//////////////////////////////////////////////////////////////////////////////////


module dual_counter(
        input logic nReset, 
        input logic clk,
        output [9:0] a_val, b_val,
        input en,
        //(* mark_debug = "true", keep = "true" *)
        output logic A, B
    );
    
    logic clk_b;
    logic a_en, b_en;
    
    logic [9:0] a_val, b_val;
    
        
    
    // Up to 823 (I assume this is for HSync?)
    bin_counter #(
        .MAX_COUNT(800), 
        .WIDTH(10)
    )
    counter_A(
        .nReset(nReset),
        .clk(clk),
        .c_en(a_en),
        .val(a_val)
    );
    
    // Up to 600 (I assume for VSync)
    bin_counter #(
            .MAX_COUNT(525),
            .WIDTH(10)
    ) 
    counter_B( 
            .nReset(nReset),
            .clk(clk),
            .c_en(b_en),
            .val(b_val)
    );
    
    assign a_en = en;
    
    assign b_en = (a_val==800); // Triggers on A limit reach
    
    
    // Front Porch | Video | SYNC | Back Porch
    
    // HSYNC 
    assign A = ~((a_val >= 656) && (a_val < 752));
    
    // VSYNC
    assign B = ~((b_val >= 490) && (b_val < 492));    
endmodule
