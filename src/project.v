/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_asiclab_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
    wire reset = ~rst_n;
    assign uio_out = 0;         // Default: no output on uio_out
    assign uio_oe = 8'b11111111; // Enable all pins for output
    wire _unused = &{ena, uio_in, 1'b0}; // Prevent unused warnings

    always @(posedge clk or negedge reset) begin
        if(reset) begin
            uo_out <= 0;          // Reset output
        end else begin
            // Example operation: add upper and lower nibbles
            uo_out[3:0] <= ui_in[7:4] + ui_in[3:0]; // Sum the nibbles
            uo_out[7:4] <= 0;         // Set upper nibble to 0
        end
    end

    // Example logic for uio_out based on uio_in, this could be extended based on requirements
    always @(posedge clk or negedge reset) begin
        if (reset) begin
            // Reset uio_out to 0 if reset is active
            uo_out <= 8'b0;
        end else if (ena) begin
            // Update uio_out with some simple transformation, e.g., mirror the uio_in
            uo_out <= uio_in;  
        end
    end

    // Enable logic for IO, assuming we're handling inputs/outputs with `uio_oe`
    always @(posedge clk or negedge reset) begin
        if (reset) begin
            uio_oe <= 8'b00000000; // Disable all IOs on reset
        end else if (ena) begin
            // For example, enable output on even-indexed IOs
            uio_oe <= 8'b01010101;  // Just a simple pattern for demonstration
        end
    end

endmodule
