# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import RisingEdge
from cocotb.triggers import FallingEdge

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0x00
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Test project behavior")

    # Program the computer

    # Manually setting the first bit (prog_mode) and Program the clock count max, let's make it 0, so it's 1-to-1 
    dut.ui_in.value = dut.ui_in.value | 0x01 | (0x01 << 5)  # Set the first and fifth bits to 1
    dut._log.info("Setting prog_mode to 1 to program the computer.")
    dut._log.info("Setting the fifth bit to 1 for clock change mode")
    
    await RisingEdge(dut.clk)  # Wait for the next rising edge  
    # Prepare to manipulate the sixth bit based on clockMaxCount value
    clockMaxCount = 0x0000
    dut._log.info(f"Value of ui_in after clearing 6th bit: {dut.ui_in.value}")
    for i in range(32):
        bitAtValue = (clockMaxCount >> i) & 0x1  # Extract the bit value at position 'i'
        if bitAtValue == 1:
            dut.ui_in.value  = dut.ui_in.value | 0x40  # Set the sixth bit to 1
            dut._log.info(f"Cycle {i}: Set sixth bit to 1.")
        else:
            dut.ui_in.value = dut.ui_in.value & ~0x40  # Clear the sixth bit
            dut._log.info(f"Cycle {i}: Cleared sixth bit to 0.")
        
        await ClockCycles(dut.clk, 1)  # Wait for one clock cycle after each bit manipulation

    await RisingEdge(dut.clk)
    # Clean up by clearing the fifth bit, which was set earlier
    dut.ui_in.value = dut.ui_in.value & ~0x20  # Clear the fifth bit (bit 5)
    dut._log.info("Cleared the fifth bit after loop execution.")

    await ClockCycles(dut.clk, 5)  # Wait for one clock cycle
    await FallingEdge(dut.clk)  # Wait for one clock cycle
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
                dut.ui_in.value = (dut.ui_in.value & 0b11100001) | shifted_address  # Mask out bits 1-4 and OR in the new address
                dut.uio_in.value = value
                
                await FallingEdge(dut.clk)  # Wait for one clock cycle
                line_number += 1

    await ClockCycles(dut.clk, 10)  # Wait for ten clock cycles

    dut.ui_in.value = (dut.ui_in.value & 0xFE) #Set the first bit to 0
    dut._log.info(f"Setting prog_mode to 0 to let the computer execute the program")

    #wait until the output enable is set to 1
    enableOut = False

    while not enableOut:
        await RisingEdge(dut.clk)
        dut._log.info(f"Output value: {dut.uo_out.value}")
        if 'x' in str(dut.uo_out.value):
            # Handle the 'x' case, possibly by assigning a default value
            enableOut = False  # Example default behavior
        else:
            enableOut = (dut.uo_out.value & 1) == 1
    
    dut._log.info("Output enabled")
    #log the uo_out value   
    dut._log.info(f"Output value: {dut.uo_out.value}")
    dut._log.info(f"Output data: {dut.uio_out.value}")

    expected_output_value = 42  # Expected output value
    # Example assertion to ensure functionality
    assert dut.uio_out.value == expected_output_value, "Test failed: Output does not match expected value"

    await ClockCycles(dut.clk, 20)  # Wait for more clock cycles for the program to finish

    dut._log.info("End")
