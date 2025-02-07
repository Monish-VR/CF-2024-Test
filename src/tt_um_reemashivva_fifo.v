/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`include "timescale.vh"
`timescale 1ns/1ps

parameter WIDTH = 4;
parameter DEPTH = 8;

module tt_um_reemashivva_fifo (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

// Internal clock signals generated by clock divider
wire w_clk; // Write clock
wire r_clk; // Read clock

// Internal wires for FIFO control and synchronization
wire [$clog2(DEPTH)-1:0] waddr;    // Write address
wire [$clog2(DEPTH)-1:0] raddr;    // Read address
wire [$clog2(DEPTH):0] wptr;       // Write pointer
wire [$clog2(DEPTH):0] rptr;       // Read pointer
wire [$clog2(DEPTH):0] wsync_ptr2; // Synchronized read pointer in write clock domain
wire [$clog2(DEPTH):0] rsync_ptr2; // Synchronized write pointer in read clock domain

wire wr_rq = ui_in[2];
wire rd_rq = ui_in[3];
reg [3:0] wdata;
wire [3:0] rdata;
wire full, empty;

always @(*) begin
    wdata[0] = ui_in[4];
    wdata[1] = ui_in[5];
    wdata[2] = ui_in[6];
    wdata[3] = ui_in[7];
end

assign uo_out = {2'b00, rdata[3:0], empty, full};

// All output pins must be assigned. If not used, assign to 0.
assign uio_out = 0;
assign uio_oe  = 0;

// List all unused inputs to prevent warnings
wire _unused = &{ena, ui_in[0], ui_in[1], uio_in[7:0]};

// Instantiate the clock divider
clock_divider clk_div_inst (
    .clk(clk),
    .reset(~rst_n),
    .w_clk(w_clk),
    .r_clk(r_clk)
);

// Instantiate synchronization and FIFO modules
sync_r2w #(.DEPTH(DEPTH)) sync_r2w_inst (
    .rptr(rptr),
    .w_clk(w_clk),
    .rst_n(rst_n),
    .wsync_ptr2(wsync_ptr2)
);

sync_w2r #(.DEPTH(DEPTH)) sync_w2r_inst (
    .wptr(wptr),
    .r_clk(r_clk),
    .rst_n(rst_n),
    .rsync_ptr2(rsync_ptr2)
);

fifo_mem #(.WIDTH(WIDTH), .DEPTH(DEPTH)) fifomem_inst (
    .w_clk(w_clk),
    .r_clk(r_clk),
    .wr_rq(wr_rq),
    .rd_rq(rd_rq),
    .full(full),
    .empty(empty),
    .waddr(waddr),
    .raddr(raddr),
    .wdata(wdata),
    .rdata(rdata)
);

full #(.WIDTH(WIDTH), .DEPTH(DEPTH)) full_inst (
    .w_clk(w_clk),
    .rst_n(rst_n),
    .wr_rq(wr_rq),
    .wsync_ptr2(wsync_ptr2),
    .waddr(waddr),
    .wptr(wptr),
    .full(full)
);

empty #(.WIDTH(WIDTH), .DEPTH(DEPTH)) empty_inst (
    .r_clk(r_clk),
    .rst_n(rst_n),
    .rd_rq(rd_rq),
    .rsync_ptr2(rsync_ptr2),
    .raddr(raddr),
    .rptr(rptr),
    .empty(empty)
);

endmodule

 

  
       
