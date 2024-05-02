/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_eater_8bit (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    
    //the first bit of the inputs is prog_mode. pick it out and give it a name
    wire prog_mode = ui_in[0];

    //the next four bits are the address in RAM we want to store the data in
    wire [3:0] addr = ui_in[4:1];

    wire output_enable;
    assign uo_out[0] = output_enable;

    //instantiation of the 8-bit eater
    //the name of the top module is 'eightBit'
    eightBit eightBit_inst (
        .prog_mode(prog_mode),
        .addr(addr),
        .data(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .fastClk(clk),
        .rst(rst_n),
        .output_enable(output_enable),
    );

endmodule
