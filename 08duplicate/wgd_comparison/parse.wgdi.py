import sys


wgdi_file = sys.argv[1]
output = sys.argv[2]
out_put_handle = open(output, 'w')


flag = False
with open(wgdi_file) as f:
    for line in f:
        if line.startswith('#'):
            # enter block
            header_list = line.split()
            chr_pair = header_list[6]
            if chr_pair.split("&")[0] == chr_pair.split("&")[1]:
                # this block need to be filtered.
                flag = True
            else:
                flag = False
            out_put_handle.write(line)
        else:
            if flag:
                row_list = line.split()
                if int(row_list[1]) - int(row_list[3]) >= 500:
                    out_put_handle.write(line)
                else:
                    pass
            else:
                out_put_handle.write(line)
out_put_handle.close()
