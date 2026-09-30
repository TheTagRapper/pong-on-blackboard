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
        (* mark_debug = "true", keep = "true" *)
        output logic [11:0] a_val, b_val,
        input en,
        //(* mark_debug = "true", keep = "true" *)
        output logic A, B
    );
    
    logic clk_b;
    logic a_en, b_en;
    
    
        
    
	// Count through entire Horizontal
    bin_counter #(
        .MAX_COUNT(2200), 
        .WIDTH(12)
    )
    counter_A(
        .nReset(nReset),
        .clk(clk),
        .c_en(a_en),
        .val(a_val)
    );
    
    // Count through entire Vertical
    bin_counter #(
            .MAX_COUNT(1126),
            .WIDTH(12)
    ) 
    counter_B( 
            .nReset(nReset),
            .clk(clk),
            .c_en(b_en),
            .val(b_val)
    );
    
    assign a_en = en;
    
    assign b_en = (a_val==2200); // Triggers on A limit reach
    
    
    // Front Porch | Video | SYNC | Back Porch
    
    // HSYNC 
    assign A = ~((a_val >= 2008) && (a_val < 2052));
    
    // VSYNC
    assign B = ~((b_val >= 1084) && (b_val < 1089));    
endmodule
