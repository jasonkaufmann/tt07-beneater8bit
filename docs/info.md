<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is Ben Eater's 8 Bit computer on an ASIC!

## How to test

To program the computer follow these steps:
  - enable my design in TT
  - send prog_mode bit high
  - on each next clock pulse, put the 8 bit data you wanna store on the I/0 lines
  - since this computer only has a 4 bit address space you can only store 18
  - see https://eater.net/8bit/ on how to program the computer (what the opcodes are)

## External hardware

You will want to make the output register on a breadboard to connect it to the 8 bit I/O lines. See https://eater.net/8bit/output for detailed design info.
