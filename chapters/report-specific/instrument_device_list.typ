#import "../../helpers/lib.typ": *


#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (left, center, left),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { luma(230) } else if calc.odd(row) { luma(250) } else { none },
    
    table.header(
      [*Type*], 
      [*Serial Number*], 
      [*Notes*]
    ),
    
    [FPGA Design Tool \ _Vivado_], 
    [-], 
    [Synthesis, implementation, and bitstream generation (Version 2019.1)],
    
    [USB Logic Analyzer & Oscilloscope \ _Analog Discovery 3_], 
    [-], 
    [Hardware measurement, signal observation, and stimulus generation],
    
    [Instrument Software \ _WaveForms_], 
    [-], 
    [Software interface used to control the Analog Discovery 3]
  ),
  caption: [Instrument and Software Device List]
) <tab:instrument_device_list>