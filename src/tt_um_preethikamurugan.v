/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

`timescale 1ns/1ps

module tt_um_preethikamurugan (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [7:0] LED
    assign uo_out = LED;
    wire w_1Hz;

    wire _unused = &{ena, ui_in[7:0], uio_in[7:0]};
    assign uio_out = 0;
    assign uio_oe = 0;
    
    lfsr8 r8(
        .clk(w_1Hz),
        .reset(~rst_n),
        .lfsr(LED)
    );
    
    oneHz_gen uno(
        .clk_100MHz(clk),
        .reset(~rst_n),
        .clk_1Hz(w_1Hz)
    );
     
endmodule
 

  
       
