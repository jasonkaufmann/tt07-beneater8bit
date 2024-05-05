# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    #dut.ui_in.value = 20
    #dut.uio_in.value = 30

    # Program the computer
    # The first bit of the inputs is prog_mode. Pick it out and give it a name.
    # Handling bit manipulation by converting value to an integer
    ui_in_value = dut.ui_in.value.integer
    prog_mode = ui_in_value & 0x1  # Extract the first bit
    dut._log.info(f"Prog_mode initial value: {prog_mode}")

    # Manually setting the first bit (prog_mode)
    dut.ui_in.value = ui_in_value | 0x1  # Set the first bit to 1
    prog_mode = dut.ui_in.value.integer & 0x1  # Re-extract the first bit
    dut._log.info(f"Prog_mode after setting to 1: {prog_mode}")

    # The next four bits are the address in RAM we want to store the data in
    addr = (ui_in_value >> 1) & 0xF  # Shift right by 1 and mask the next 4 bits
    dut._log.info(f"Address extracted from ui_in: {addr}")

    dut._log.info("Test project behavior")

    #Open the output.txt file and read lines
    with open("output.txt", "r") as file:
        line_number = 0
        for line in file:
            binary_value = line.strip()  # Read and strip each line
            if binary_value:  # Ensure the line is not empty
                value = int(binary_value, 2)  # Convert binary string to integer

                # Log the values
                dut._log.info(f"Address {line_number}: value={value}")
                
                address_4bit = line_number % 16  # Get a 4-bit number
                shifted_address = address_4bit << 1  # Shift left by 1 to place it into bits 1 to 4

                # Set bits 1 to 4 of dut.ui_in to address_4bit
                dut.ui_in.value = (dut.ui_in.value & 0b11110001) | shifted_address  # Mask out bits 1-4 and OR in the new address
                dut.uio_in.value = value
                
                await ClockCycles(dut.clk, 1)  # Wait for one clock cycle
                line_number += 1


    # Example assertion to ensure functionality
    #assert dut.data_output.value == expected_output_value, "Test failed: Output does not match expected value"