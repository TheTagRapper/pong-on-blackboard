`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2026 12:19:18 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer #(
    parameter CLK_FREQ_HZ = 100_000_000,  // your board's raw clk frequency
    parameter DEBOUNCE_MS = 10             // stable time required, in ms
) (
    input  logic clk,
    input  logic btn_in,      // raw, noisy button input (active-high)
    output logic btn_out      // debounced, synchronized output (active-high)
);

    localparam int COUNT_MAX = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
    localparam int CTR_WIDTH = $clog2(COUNT_MAX + 1);

    // Stage 1-2: synchronize the raw async input into this clock domain
    logic btn_sync_0, btn_sync_1;
    always_ff @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end

    // Stage 3: only accept a new value once it's been stable for COUNT_MAX cycles
    logic [CTR_WIDTH-1:0] count;
    logic btn_stable;

    always_ff @(posedge clk) begin
        if (btn_sync_1 == btn_stable) begin
            // input agrees with current stable output, no bounce happening
            count <= 0;
        end else begin
            // input disagrees, count how long it's held
            count <= count + 1;
            if (count >= COUNT_MAX) begin
                btn_stable <= btn_sync_1;
                count <= 0;
            end
        end
    end

    assign btn_out = btn_stable;

endmodule
