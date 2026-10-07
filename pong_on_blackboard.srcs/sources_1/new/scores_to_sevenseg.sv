`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 01:06:34 PM
// Design Name: 
// Module Name: scores_to_sevenseg
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


module scores_to_sevenseg(
        input logic clk,
        input logic sevseg_clk, 
        input logic nReset,
        input logic p1_scored,
        input logic p2_scored,
        output logic [7:0] seg_cat,
        output logic [3:0] seg_an
    );
    
    // Debounce inputs
    logic p1_debounced;
    logic p2_debounced;
    
    
    debouncer #(.CLK_FREQ_HZ(75_125_000), .DEBOUNCE_MS(500)) db_p1 (.clk(clk), .btn_in(p1_scored), .btn_out(p1_debounced));
    debouncer #(.CLK_FREQ_HZ(75_125_000), .DEBOUNCE_MS(500)) db_p2 (.clk(clk), .btn_in(p2_scored), .btn_out(p2_debounced));    
    
    // Trigger increment
    logic [3:0] p1_tens, p1_ones, p2_tens, p2_ones;
    
    always_ff @(posedge clk or negedge nReset)
    begin
        if (~nReset)
        begin
            {p1_tens, p1_ones, p2_tens, p2_ones} <= 0;
        end
        else if (p1_debounced && p1_tens != 9 && p1_ones != 9)
        begin
            if (p1_ones == 9) 
            begin
                p1_ones <= 0; 
                p1_tens <= p1_tens + 1;
            end
            else p1_ones <= p1_ones + 1;
        end
        else if (p2_debounced && p2_tens != 9 && p2_ones != 9)
        begin
            if (p2_ones == 9) 
            begin
                p2_ones <= 0; 
                p2_tens <= p2_tens + 1;
            end
            else p2_ones <= p2_ones + 1;
        end
    end
    
    // Write to Sev Seg 
    logic [1:0] digit;
    
    logic [3:0] write_value;
    logic [7:0] cathodes;
    assign cathodes = seg_cat;
    logic is_active;
    assign is_active = 1;
    logic is_decimal;
    
    sevenseg_decoder ss_dec (.hexval(write_value), .cathodes(cathodes), .active(is_active), .is_decimal(is_decimal));
    
    always_ff @(posedge sevseg_clk or negedge nReset)
    begin
        if (~nReset)
        begin
            write_value <= p1_tens;
            is_decimal <= 0;
            digit <= 0;
        end
        else if (digit == 0)
        begin
            seg_an <= 4'b1000;
            write_value <= p1_tens;
            is_decimal <= 0;
        end
        else if (digit == 1)
        begin
            seg_an <= 4'b0100;
            write_value <= p1_ones;
            is_decimal <= 1;
        end
        else if (digit == 2)
        begin
            seg_an <= 4'b0010;
            write_value <= p2_tens;
            is_decimal <= 0;
        end
        else if (digit == 3)
        begin
            seg_an <= 4'b0001;
            write_value <= p2_ones;
            is_decimal <= 0;
        end
        digit <= digital + 1;
    end
    
    
endmodule
