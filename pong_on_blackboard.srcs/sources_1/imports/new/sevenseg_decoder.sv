`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 05:40:56 PM
// Design Name: 
// Module Name: sevenseg_decoder
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

module sevenseg_decoder(
    input logic [3:0] hexval,
    output logic [7:0] cathodes,
    input logic active,
    input logic decimal
);

always_comb
begin
    if(active)
    begin
        case(hexval)
            0: cathodes[6:0] = 7'b1000000;
            1: cathodes[6:0] = 7'b1111001;
            2: cathodes[6:0] = 7'b0100100;
            3: cathodes[6:0] = 7'b0110000;
            4: cathodes[6:0] = 7'b0011001;
            5: cathodes[6:0] = 7'b0010010;
            6: cathodes[6:0] = 7'b0000010;
            7: cathodes[6:0] = 7'b1111000;
            8: cathodes[6:0] = 7'b0000000;
            9: cathodes[6:0] = 7'b0010000;
            10: cathodes[6:0] = 7'b0001000;
            11: cathodes[6:0] = 7'b0000011;
            12: cathodes[6:0] = 7'b1000110;
            13: cathodes[6:0] = 7'b0100001;
            14: cathodes[6:0] = 7'b0000110;
            15: cathodes[6:0] = 7'b0001110;
        endcase
    end
    else
        cathodes[6:0] = 7'b1111111;
end

assign cathodes[7] = ~(decimal && active);

endmodule