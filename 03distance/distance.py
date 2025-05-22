import sys

distance_file = open(sys.argv[2], 'a+')
species = sys.argv[3]

with open(sys.argv[1]) as f:
    next(f)
    next(f)
    flag = False
    index = 0
    for line in f:
        if line.startswith("#"):
            # block start
            flag = True
            index += 1
            block_length = line.split()[2].split("=")[1]
        else:
            line_list = line.split()
            if flag:
                prv_ref_id = line_list[2]
                prv_qry_id = line_list[7]
                flag = False
                continue
            else:
                ref_id = line_list[2]
                ref_dif = int(ref_id) - int(prv_ref_id)
                qry_id = line_list[7]
                qry_dif = int(qry_id) - int(prv_qry_id)

                # query distance, ref distance and block length, species
                distance_file.write(species + "\t" + str(qry_dif) + "\t" + str(ref_dif) + "\t" + block_length + "\n")

                prv_ref_id = ref_id
                prv_qry_id = qry_id

distance_file.close()


