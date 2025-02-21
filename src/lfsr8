`timescale 1ns / 1ps

// 8-bit Linear Feedback Shift Register LFSR
// XNOR version - reset to 00000000
// *For XOR version - begin lfsr reg at 4'b1111 - reset to 1111 --> EDIT THIS

module lfsr4(
    input clk,
    input reset,
    output reg [7:0] lfsr = 8'b0
    );
    
    always @(posedge clk or posedge reset)
        if(reset)
            lfsr <= 8'b0;
        else begin
            lfsr[7:1] <= lfsr[6:0];
            lfsr[0] <= lfsr[7] ~^ lfsr[0];
        end
       
endmodule
