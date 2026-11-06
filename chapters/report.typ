= Task Description
The objective of this laboratory exercise is to design and implement a 9-bit Circular Parallel-In Serial-Out (PISO) Shift Register with an additional parity output on the Digilent Basys 3 (Xilinx Artix-7) FPGA. The circuit must operate at an effective shifting and loading clock frequency of 5 MHz, which is derived by deviding the 100 MHz system clock by a factor of 20.

Functional requirements (features) of the circuit:
- *Asynchronous active-high reset input*
- *Input synchronization  & Push-button edge detection*
- *Right-shift operation (LSB first) & Circular Mode*
- *Parallel load of 9-bit data input*
- *Even parity output*


#figure(
  table(
    columns: (1fr, 2fr),
    align: (left, left),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },
    
    table.header(
      [*Parameter*], 
      [*Specification*]
    ),
    
    [Target Device], [Digilent Basys 3 (Xilinx Artix-7 XC7A35T-1CPG236C)],
    [Design Language], [SystemVerilog],
    [System Clock], [100 MHz Board Clock],
    [Operating Frequency], [5 MHz (derived by factor of 20)],
    [Core Architecture], [9-bit Circular PISO Shift Register with Even Parity]
  ),
  caption: [Design Specifications Summary]
) <tab:design_specs>


= Source Code

== Design Module (`design.sv`)
The design.sv file implements the core RTL logic in "module piso_9bit_parity" for a 9-bit Circular Parallel-In Serial-Out (PISO) Shift Register with an even parity output operating in the 5 MHz clock domain. Firstly, it synchonizes the external asynchronous board inputs from push-buttons and switches, which can be seen in @listing:sync

#figure(
  raw(read("../assets/src/design.sv").split("\n").slice(24, 41).join("\n"), lang: "systemverilog", block: true),
  caption: [ Input synchronization via 2-flip-flop synchronizer stage (`design.sv`)],
) <listing:sync>

In @listing:9-bit-shift-register, the 9-bit Circular PISO Shift Register is implemented with an active high asynchronous reset input and a synchronous parallel load. On all other clock cycles, it shifts the register one bit to the right (LSB first) while multiplexing either the outgoing LSB (shift_reg[0]) for circular rotation or fills a zero into MSB if circular mode is disabled. 
#figure(
  raw(read("../assets/src/design.sv").split("\n").slice(58, 71).join("\n"), lang: "systemverilog", block: true),
  caption: [ Input synchronization via 2-flip-flop synchronizer stage (`design.sv`)],
) <listing:9-bit-shift-register>
The complete code can be seen in @ch:appendix_source_code

#pagebreak()
== Testbench (`tb.sv`)
The testbench (`tb.sv`) implements the tests of the 9-bit circular PISO shift register with parity output (`piso_9bit_parity`) by instantiating it as the Device Under Test (DUT). All tests performed to verify the functionality of the shift register are displayed in @tab:tb_scenarios and the source code can be seen in @ch:appendix_source_code. The simulations results are displayed and discussed in @ch:sim-results

#figure(
  table(
    columns: (auto,  1fr, 1.5fr),
    align: (center + horizon, left, left, left),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },
    
    table.header(
      [*Test*], 
      [*Description*], 
      [*Expected Observation*]
    ),
    
    [1], 
    [Initial Reset],  
    [System initialization and baseline setup.],
    
    [2], 
    [Parallel Load & Circular Shift (Even 1s)], 
    [Full 9-bit circular rotation with constant `parity_out = 0`.],
    
    [3], 
    [Parallel Load & Circular Shift (Odd 1s)], 
    [Full 9-bit circular rotation with constant `parity_out = 1`.],
    
    [4], 
    [Circular Shift Disabled], 
    [Zeros shift into the register; `parity_out` toggles as 1s exit.],
    
    [5], 
    [Asynchronous Reset Operation], 
    [`shift_reg_out` clears to zeros immediately (asynchronously) mid-operation.]
  ),
  caption: [Testbench scenarios implemented in tb.sv for the 9bit-PISO shift register]
) <tab:tb_scenarios>

== Pin Constraints (`pinout.xdc`)
To guarantee correct synthesis and hardware implementation on the Basys 3 board, the 100 MHz oscillator must be explicitly constrained which can be seen in @listing:xdc. The following snippet binds the top-level clock port to physical pin `W5` and defines a 10.00 ns timing constraint, enabling Vivado's static timing analyzer to properly evaluate signal propagation delays across the design.


#figure(
  raw(read("../assets/src/pinout.xdc").split("\n").slice(1, 3).join("\n"), lang: "tcl", block: true),
  caption: [Basys 3 Physical Pin Constraints (`pinout.xdc`)],
) <listing:xdc>
The remaining I/O constraints map the design's input and output ports to standard board peripherals and PMOD headers for verification which can be seen in @ch:appendix_source_code.

#pagebreak()
== Block Design
To create a block design, first the `piso_9bit_parity` module is wrapped in a Verilog wrapper file, so it can be used in the design. The block design can be seen in @fig:block_design. The Clocking Wizard takesthe external 100 MHz board clock (clk_100mhz) and divides it down to generate the 5 MHz internal clock (clk_out1) required by the 9-bit shift register. 

The Processor System Reset block is a dedicated Xilinx reset controller that ensures safe startup and reset sequencing. Additionally, a inverter block for the rst is used to get an active-high reset signal for the shift register.
#figure(
  image("../assets/src/BlockDesign.png", width: 100%),
  caption: [Block Design of the 9-bit Circular PISO Shift Register with Parity Output],
) <fig:block_design>
The resulting block design file .bd is again wrapped using the integrated "Create HDL wrapper" feature in Vivado. This file is the set as top-level module for synthesis and implementation. 
= Simulation Results <ch:sim-results>
#figure(
  image("../assets/graphics/01_Simulation/TEST1_CLOCK.png", width: 100%),
  caption: [TEST1 and measurement of the clock signal],
) <fig:sim_test1>

In @fig:sim_test1, the first testbench scenario (TEST1) is shown which shows the inital reset. During this test, the system is initialized and the baseline setup is established. The clock signal is measured and a value of 200ns is read out which corresponds to a frequency of 5 MHz.

#figure(
  image("../assets/graphics/01_Simulation/TEST2_TEST3.png", width: 100%),
  caption: [TEST2 and TEST3 with circular shifting enabled and parallel load of 9-bit data input],
) <fig:sim_test2_3>

In @fig:sim_test2_3, the second and third testbench scenarios (TEST2 and TEST3) are shown. Here circular shifting is enabled and the 9-bit shift register is loaded with a value of 0x151 (TEST2) and 0x1D1 (TEST3). The expected behavior is observed, where the parity output remains constant at 0 for TEST2 and at 1 for TEST3, as the number of 1s in the register is even and odd, respectively.

#figure(
  image("../assets/graphics/01_Simulation/TEST4.png", width: 100%),
  caption: [TEST4 with circular shifting disabled and parallel load of 9-bit data input],
) <fig:sim_test4>

In @fig:sim_test4, the fourth testbench scenario (TEST4) is shown. Here circular shifting is disabled.The expected behavior is observed, where zeros shift into MSB of the register and the parity output toggles as 1s exit the register.

#figure(
  image("../assets/graphics/01_Simulation/TEST5.png", width: 100%),
  caption: [TEST5 testing reset operation],
) <fig:sim_test5>

In @fig:sim_test5, the fifth testbench scenario (TEST5) is shown. Here active-highreset operation is tested. The expected behavior is observed, where the shift register output clears to zeros immediately.


= Synthesis Reports
== Clock Network Report
The clock network report which can be seen in @fig:clock_network_report shows the clock tree of the design. It confirms that the CLock Wizard correctly divides the 100 MHz input clock to the required 5 MHz clock for the synthesis run. The additionally generated 20 MHz clock signal is an internal feedback loop clock used to keep the output frequency locked and stable.
#figure(
  image("../assets/graphics/02_Synthesis/ClockNetworkReport.png", width: 100%),
  caption: [Clock Network Report],
) <fig:clock_network_report>
== Timing Summary
- Setup (Worst Negative Slack): Setup time ensures data arrives at a flip-flop early enough before the next clock edge.Because WNS=196ns. The logic path delay with the 5 MHz clock is only about 4 ns. 
- Hold (Worst Hold Slack - WHS): Hold time ensures data remains stable for a minimum duration after the clock edge so it isn't accidentally overwritten too early.

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left, center, center, center),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },
    
    table.header(
      [*Metric*], 
      [*Setup*], 
      [*Hold*], 
      [*Pulse Width*]
    ),
    
    [Worst Slack], 
    [196.173 ns (WNS)], 
    [0.059 ns (WHS)], 
    [3.000 ns (WPWS)],
    
    [Total Negative Slack], 
    [0.000 ns (TNS)], 
    [0.000 ns (THS)], 
    [0.000 ns (TPWS)],
    
    [Failing Endpoints], 
    [0], 
    [0], 
    [0],
    
    [Total Endpoints], 
    [119], 
    [119], 
    [82]
  ),
  caption: [Design Timing Summary ]
) <tab:timing_summary>
#pagebreak()
== Utilization Report
The utilization report which can be seen in @tab:utilization_simple details the FPGA resources consumed by the design, indicating that the 9-bit PISO shift register logic utilizes 31 Slice LUTs and 72 Slice Registers. 
#align(center)[
  #figure(
    table(
      columns: 4,
      align: (left, center, center, center),
      stroke: 0.5pt + luma(200),
      fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },
      
      table.header(
        [*Resource Type*], [*Used Count*], [*Available on Artix-7*], [*Utilization (%)*]
      ),
      
      [Slice LUTs], [31], [20,800], [< 1%],
      [Slice Registers (Flip-Flops)], [72], [41,600], [< 1%],
      [Bonded I/O Pins (IOB)], [26], [106], [24.5%],
      [Clock Buffers (BUFGCTRL)], [2], [32], [6.3%],
      [Mixed-Mode Clock Managers (MMCM)], [1], [5], [20.0%]
    ),
    caption: [Artix-7 FPGA Resource Utilization]
  ) <tab:utilization_simple>
]
= Hardware Measurements
The plot in @fig:hardware_measurements illustrates the hardware execution of the 9-bit Circular PISO Shift Register during active circular rotation  at the 5 MHz clock frequency. The initial load strobe loads the shift register with 0b111010001 configured with the switches on the Basys3 board. During the subsequent rotation phase, the `serial_out` signal continuously streams the LSB, while the `parity_out` correctly remains steady, confirming the register's contents are preserved as they loop from the LSB back to the MSB.
#figure(
  image("../assets/data/analog_discovery_plot_cycle_EN.svg", width: 100%),
  caption: [Measurement of the 9-bit Circular PISO Shift Register on the Basys3 board with active circular roatation],
) <fig:hardware_measurements>
  
#pagebreak()

When circular rotation is disabled as can be seen in @fig:hardware_measurements_disabled (`circ_en = 0`), the register no longer feeds the LSB back to the MSB, instead it shifts in zeros. The plot shows that as the remaining 1s from the loaded word shift out through `serial_out`, the `parity_out` bit correctly toggles each time a 1 exits the register, eventually settling to 0 once the register is completely emptied of 1s.
#figure(
  image("../assets/data/analog_discovery_plot_cycle_Dis.svg", width: 100%),
  caption: [Measurement of the 9-bit Circular PISO Shift Register on the Basys3 board with disabled circular rotation],
) <fig:hardware_measurements_disabled>
#pagebreak()