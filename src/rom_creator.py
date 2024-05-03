# Import necessary libraries
import re

def parse_data_from_file(file_path):
    # This list will hold tuples of parsed data for each instruction
    microcode = []
    
    with open(file_path, 'r') as file:
        for line in file:
            # Assuming data is commented out with '//' and uses comma separators
            if '//' in line:
                line = line.split('//')[0].strip()  # Removes the comment part
                if line:
                    tokens = [token.strip() for token in line.split(',')]
                    microcode.append(tokens)
    
    return microcode

def write_systemverilog_file(microcode, sv_file_path):
    with open(sv_file_path, 'w') as file:
        file.write('logic [15:0] memory [{}];\n'.format(len(microcode)))
        file.write('initial begin\n')
        for index, tokens in enumerate(microcode):
            # Joining tokens to create the SystemVerilog array initialization
            data_line = ' ' * 4 + 'memory[{}] = 16\'b{};\n'.format(index, '_'.join(tokens))
            file.write(data_line)
        file.write('end\n')

# Use the functions
input_file_path = 'rom_decoder.txt'  # Path to your input file
output_sv_path = 'decoder_matrix.sv'  # Output SystemVerilog file
microcode = parse_data_from_file(input_file_path)
write_systemverilog_file(microcode, output_sv_path)
