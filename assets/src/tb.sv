`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: finklu
// Project Name: lab01_PISOshiftregister
//////////////////////////////////////////////////////////////////////////////////
module tb ();
    logic       clk        = 1'b0;
    logic       rst        = 1'b0;
    logic       load_btn   = 1'b0;
    logic       circ_en    = 1'b0;
    logic [8:0] data_in    = 9'b000000000;
    
    logic       clk_out;
    logic       parity_out;
    logic       serial_out;
    logic       load_strobe_out;
    logic [8:0] shift_reg_out;

    piso_9bit_parity uut (
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

    // 5 MHz clock generation (200 ns period)
    always #100 clk = ~clk;

    initial begin
        // TEST 1: Initial Reset
        rst      = 1'b1;
        load_btn = 1'b0;
        circ_en  = 1'b0;
        data_in  = 9'b101100111;
        #300;
        rst      = 1'b0;
        #600;

        // TEST 2: Parallel Load & Circular Shift Enabled (Even 1s -> parity_out = 0)
        circ_en  = 1'b1;
        data_in  = 9'b101010001; // 4 ones (0x151) -> parity_out = 0
        #600;                    // Pass 2-FF input synchronizer
        
        load_btn = 1'b1;         // Pulse load button
        #400;
        load_btn = 1'b0;

        // Wait 2400 ns (12 clock cycles) to observe full 9-bit circular rotation
        #2400;

        // TEST 3: Load pattern with odd 1s (5 ones -> parity_out = 1)
        data_in  = 9'b111010001; // 5 ones (0x1D1) -> parity_out = 1
        #600;
        
        load_btn = 1'b1;
        #400;
        load_btn = 1'b0;

        // Observe circular rotation with constant parity_out = 1
        #2400;

        // TEST 4: Circular Shift Disabled (Shifting Zeros In -> parity_out toggles)
        circ_en = 1'b0; 
        #2400;

        // TEST 5: Asynchronous Reset Operation (Load 1FF, then reset mid-operation)
        circ_en  = 1'b1;
        data_in  = 9'b111111111; // 0x1FF
        #600;
        load_btn = 1'b1;
        #400;
        load_btn = 1'b0;
        #800;

        rst = 1'b1; // Immediately clears shift_reg_out to 000 asynchronously!
        #400;
        rst = 1'b0;
        #800;

        $finish;
    end
endmodule