`timescale 1ns / 1ps

module piso_9bit_parity_wrapper (
    input  wire       clk,
    input  wire       rst,
    input  wire       load_btn,
    input  wire       circ_en,
    input  wire [8:0] data_in,
    output wire       serial_out,
    output wire       parity_out,
    output wire       clk_out,
    output wire       load_strobe_out,
    output wire [8:0] shift_reg_out
);

    piso_9bit_parity u_piso_9bit_parity (
        .clk             (clk),
        .rst             (rst),
        .load_btn        (load_btn),
        .circ_en         (circ_en),
        .data_in         (data_in),
        .serial_out      (serial_out),
        .parity_out      (parity_out),
        .clk_out         (clk_out),
        .load_strobe_out (load_strobe_out),
        .shift_reg_out   (shift_reg_out)
    );

endmodule