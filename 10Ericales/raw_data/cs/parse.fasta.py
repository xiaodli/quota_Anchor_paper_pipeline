import sys


def wrap_sequence(seq, width=60):
    return '\n'.join([seq[i:i+width] for i in range(0, len(seq), width)]) + '\n'

output_file = sys.argv[2]
output_file_handle = open(output_file, "w")
with open(sys.argv[1]) as f:
    for line in f:
        if line.startswith('>'):
            output_file_handle.write(line.strip() + '\n')
        else:
            chr_info = wrap_sequence(line.strip(), 60)
            output_file_handle.write(chr_info)
