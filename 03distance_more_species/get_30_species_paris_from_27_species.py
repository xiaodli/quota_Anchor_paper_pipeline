import random
import os
import re
import sys
import itertools


abs_input_dir = sys.argv[1]
species_list = []
files_and_folders = os.listdir(abs_input_dir)
for name in files_and_folders:
    if name.endswith(".fa") and not name.startswith("Join"):
        new_name = re.sub(r'.fa$', '', name)
        species_list.append('"{}"'.format(new_name))
pairs = list(itertools.combinations(species_list, 2))
random.seed(2)
selected_pairs = random.sample(pairs, 30)

ref_list = []
query_list = []
for pair in selected_pairs:
    ref_list.append(pair[0])
    query_list.append(pair[1])

print("ref_array:")
for i in ref_list:
    print(i, end=" ")
print()
print()

print("query_array:")
for i in query_list:
    print(i, end=" ")
print()
print()