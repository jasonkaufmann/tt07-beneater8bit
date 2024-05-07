![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# How it works

This is Ben Eater's 8 Bit computer on an ASIC!

All credit for the design, amazing instructional videos, and diagams below goes to Ben Eater.

![overview-with-chip-descriptions1](https://github.com/jasonkaufmann/ice40FPGAProjects/assets/41923667/0995715c-218d-4779-85be-36083b9d3e90)

## High level overview

Full Computer Schematic:
![high_level_diagram](https://github.com/jasonkaufmann/ice40FPGAProjects/assets/41923667/f122dd7a-d9fc-4a3f-b961-beee40d9fa35)

Simple Control Signal Diagram:
![simple_diagram](https://github.com/jasonkaufmann/ice40FPGAProjects/assets/41923667/25b4c402-da54-4372-9458-7b1f4c095c3a)

*Note: The output register and logic to display the digits is not included on the ASIC. The 8 bit output value is put on the bus and the "output register in" control signal (oi) is on an output pin. This way you can use the data bus as a general purpose interface to any display you want. (i.e. you can read in the data to the RP2040 and show it on the screen, you can build the actual output register as shown in the videos and connect it to the PMOD header, etc.)

ASIC 2D:
![asic](https://github.com/jasonkaufmann/ice40FPGAProjects/assets/41923667/75a44e3f-531d-49fc-af93-cacfedb2afdd)

ASIC 3D:
![asic_3d](https://github.com/jasonkaufmann/ice40FPGAProjects/assets/41923667/da51dff7-3b9d-46f9-a9b1-e6c4dc9bc3e7)

# How to test

To program the computer follow these steps:
  - enable my design in TT
  - send prog_mode bit high
  - set the four prog_address bits to the address you want to write to, put the data you want to store at that address on the I/O lines, and then pulse the clock.
  - since this computer only has a 4 bit address space you can only store 16 bytes total in the internal RAM.
  - see https://eater.net/8bit/ for more details.
  
## Instructions
| OPC | DEC | HEX  | DESCRIPTION                                                    |
|-----|-----|------|----------------------------------------------------------------|
| NOP | 00  | 0000 |                                                                |
| LDA | 01  | 0001 | Load contents of memory address aaaa into register A.          |
| ADD | 02  | 0010 | Put content of memory address aaaa into register B, add A + B, store result in A. |
| SUB | 03  | 0011 | Put content of memory address aaaa into register B, subtract A - B, store result in register A. |
| STA | 04  | 0100 | Store contents of register A at memory address aaaa.           |
| LDI | 05  | 0101 | Load 4 bit immediate value in register A (loads 'vvvv' in A).   |
| JMP | 06  | 0110 | Unconditional jump. Set program counter (PC) to aaaa, resume execution from that memory address. |
| JC  | 07  | 0111 | Jump if carry. Set PC to aaaa when carry flag is set and resume from there. When carry flag is not set, resume normally. |
| JZ  | 08  | 1000 | Jump if zero. As above, but when zero flag is set.              |
|     | 09  | 1001 |                                                                |
|     | 10  | 1010 |                                                                |
|     | 11  | 1011 |                                                                |
|     | 12  | 1100 |                                                                |
|     | 13  | 1101 |                                                                |
| OUT | 14  | 1110 | Output register A to 7 segment LED display as decimal.         |
| HLT | 15  | 1111 | Halt execution.                                                |

# External hardware

You will need the RP2040 or a similar microcontroller to write the program into the internal memory. If you really wanted to, you could go old school and use DIP switches and a manual clock pulse as well.

You will want to make the output register on a breadboard to connect it to the 8 bit I/O lines from the PMOD header. See https://eater.net/8bit/output for detailed design info.


# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Set up your Verilog project

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Adapt the testbench to your design. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://docs.google.com/document/d/1aUUZ1jthRpg4QURIIyzlOaPWlmQzr-jBn3wZipVUPt4)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Edit [this README](README.md) and explain your design, how it works, and how to test it.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@matthewvenn](https://twitter.com/matthewvenn)
