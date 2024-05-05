def assemble_to_binary(filename):
    # Extended mapping of instructions to their binary opcodes
    opcodes = {
        'NOP': '0000',
        'LDA': '0001',
        'ADD': '0010',
        'SUB': '0011',
        'STA': '0100',
        'LDI': '0101',
        'JMP': '0110',
        'JC':  '0111',
        'JZ':  '1000',
        'OUT': '1110',
        'HLT': '1111'
    }

    # Read the input file
    with open(filename, 'r') as file:
        lines = file.readlines()

    # The output list of binary representations
    binary_output = []

    for line in lines:
        # Strip extra whitespace and split by space
        parts = line.strip().split()

        if parts[0] in opcodes:
            # If the line is an instruction, fetch the opcode and format the address
            opcode = opcodes[parts[0]]
            address = format(int(parts[1]), '04b') if len(parts) > 1 else '0000'
            binary_output.append(opcode + address)
        else:
            # If the line is a data value, simply convert it to an 8-bit binary number
            binary_output.append(format(int(parts[0]), '08b'))

    return binary_output

def save_to_file(binary_output, output_filename="output.txt"):
    # Write the binary output to a file
    with open(output_filename, 'w') as file:
        for binary in binary_output:
            file.write(binary + '\n')

# Input file name
input_filename = "program.txt"

# Assemble the code to binary
binary_output = assemble_to_binary(input_filename)

# Save the output to a file
save_to_file(binary_output)

print("Compilation to binary and file saving complete.")
