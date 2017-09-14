### Project Checkpoint 1
 - Author: Mina Mungekar
 - Course: ECE 350
 - Term: Fall 2017
 - Professor: Yiran Chen
 
 ## Design
 The register file as a whole is divided into a series of modules. On the lowest level, with the code provided to us, is the implementation for a D flip-flop. A second module, which outlines the implementation of a basic register, contains 32 of these flip-flops, generated through a single port. The register module accepts a series of inputs directly passed in from the highest level register file module, including the various ports and wires needed to construct a tri-state buffer. In this module, the output of each register is routed through two tri-state buffers which directly assign values to the read ports of the entire register file.
 
 The decoder module specifically is intended to generate an output which will moderate the value of the "enable" pin at each tri-state buffer (as well as which port's "write-enable" pin is on). To this purpose, a series of "and" gates mapping a 5:32 decoder truth table are created. 
 
 Finally, a register file module is implemented on the highest level. After three instances of a decoder are initialized to send enable signals to the registers speciied by ctrl-writeRegA, ctrl-regReadB, and ctrl-regWrite, a loop generates 32 registers, and passes each its respective inputs.
