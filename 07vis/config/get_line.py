import sys


col_list = []
len_list = []
sp_list = []
prev_sp = ""
with open(sys.argv[1], 'r') as f:
    for line in f:
        cur_sp = line.split()[0]
        if prev_sp != "":
            col = prev_sp + "_" + cur_sp + ".collinearity"
            col_list.append("/media/dell/E/Suppmentary_data/07vis/collinearity/" + col)
        else:
            pass
        len_list.append("/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/" + cur_sp + ".length.txt")
        sp_list.append(cur_sp)
        prev_sp = cur_sp
for i in range(2, len(col_list)+1):
    line_file = "line" + str(i) + ".conf"
    out = "line" + str(i) + ".png"
    with open(line_file, 'w') as f:
        input = ""
        len_input = ""
        sp_input = ""
        for j in range(0, i):
            input += col_list[j] + ","
            len_input += len_list[j] + ","
            sp_input += sp_list[j] + ","
        len_input +=  len_list[i]
        sp_input += sp_list[i]
        f.write("[line]" + "\n")
        f.write("input_file =" + input + "\n")
        f.write("length_file = " + len_input + "\n")
        f.write("species_name =" + sp_input + "\n")
        f.write("remove_chromosome_prefix = " + "\n")
        f.write("chr_font_size =" + "7"  + "\n")
        f.write("species_name_font_size =" + "10" + "\n")
        f.write("figsize =" + "\n")
        f.write("output_file_name =" + out + "\n")
