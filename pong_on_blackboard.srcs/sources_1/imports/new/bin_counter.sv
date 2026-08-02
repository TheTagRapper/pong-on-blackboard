`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 02:15:03 PM
// Design Name: 
// Module Name: bin_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Part of Real Digital Project 1
// 
//////////////////////////////////////////////////////////////////////////////////


module bin_counter #(parameter MAX_COUNT = 255, WIDTH = 8)
(
	input logic nReset, clk, c_en,
	output logic [WIDTH-1:0] val
);


    always_ff @(posedge clk or negedge nReset)
    begin
        
        if (!nReset || val == MAX_COUNT) val <= 0;
        else if (c_en) val <= val + 1;
    end

endmodule
