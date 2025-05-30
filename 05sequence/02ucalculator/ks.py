# This script refers to wgdi 's ks.py and famcircle 's ks.py and biopython 's paml module.
# https://github.com/lkiko/famCircle
# https://github.com/SunPengChuan/wgdi/blob/master/wgdi/ks.py
# https://github.com/biopython/biopython/blob/master/Bio/Phylo/PAML

import subprocess
import pandas as pd
import os, re, datetime, sys
import logging
import base
import shutil
import numpy as np
from Bio import SeqIO
from multiprocessing import Pool, cpu_count
from alive_progress import alive_bar

logger = logging.getLogger('main.ks')

def read_collinearity(collinearity):
    block_len = []
    with open(collinearity) as f:
        _ = next(f)
        _ = next(f)
        for line in f:
            if line.startswith('#'):
                record_split_list = line.split()
                pair_number_field = record_split_list[2]
                block_len.append(int(pair_number_field.split(sep="N=")[1]))
    collinearity_df = pd.read_table(collinearity, comment="#", header=0, low_memory=False, index_col=False)
    collinearity_df['refGene'] = collinearity_df['refGene'].astype(str)
    collinearity_df['queryGene'] = collinearity_df['queryGene'].astype(str)
    collinearity_df['refChr'] = collinearity_df['refChr'].astype(str)
    collinearity_df['queryChr'] = collinearity_df['queryChr'].astype(str)

    ref_gene_list = list(collinearity_df["refGene"].copy())
    query_gene_list = list(collinearity_df["queryGene"].copy())

    try:
        assert (len(ref_gene_list) == len(query_gene_list))
    except AssertionError:
        logger.error('Your collinearity file is not correct, please check it.')

    query_to_ref = list(zip(query_gene_list, ref_gene_list))
    df = pd.DataFrame(query_to_ref)
    df[0] = df[0].astype(str)
    df[1] = df[1].astype(str)
    df.index = df[0] + ',' + df[1]
    return df, block_len


class Ks:
    def __init__(self, config_pra, config_soft,parameter):
        self.prot_align_file = 'prot.aln'
        self.pair_changed_seq = 'pair.changed.seq'
        self.pair_yn = 'pair.yn'
        self.cal_input = "pair.cal.input"
        self.pair_cal = 'pair.cal'
        self.pair_pep_file = 'pair.pep'
        self.pair_cds_file = 'pair.cds'
        self.yn00_ctl = "yn00.ctl"


        self.process = 6
        self.add_ks = False

        self.method = "MA"
        self.cds_file = ""
        self.pep_file = ""
        self.collinearity = ""
        self.ks_file = ""
        self.align_software = ""
        self.mafft = ""
        self.muscle = ""
        self.pal2nal = ""
        self.yn00 =""
        self.yn00 = ""
        self.KaKs_Calculator = "KaKs_Calculator"

        self.overwrite = False
        for i in config_pra.sections():
            if i == 'ks':
                for key in config_pra[i]:
                    setattr(self, key, config_pra[i][key])
        for key, value in vars(parameter).items():
            if key != "func" and key != "analysis" and value is not None:
                setattr(self, key, value)

        self.work_dir = os.getcwd()
        for key in config_soft['software']:
            if key in ["mafft", "muscle", "pal2nal", "yn00"]:
                setattr(self, key, config_soft["software"][key])
        self.process = int(self.process)

    def merge_ks_file(self):
        if self.add_ks and os.path.exists(self.ks_file) and os.path.getsize(self.ks_file) > 0:
            output_file = open(self.ks_file, 'a')
        else:
            output_file = open(self.ks_file, 'w')
            output_file.write('\t'.join(['id1', 'id2', 'ka', 'ks', 'omega'])+'\n')
        for i in range(int(self.process)):
            path = os.path.join(self.work_dir, 'tmp', 'process_' + str(i), os.path.basename(self.ks_file) + '_' + str(i))
            file_handler = open(path, 'r')
            content = file_handler.read()
            output_file.write(content)
            file_handler.close()
        output_file.close()


    # inter speices
    def pair_kaks(self, gene1, gene2):
        self.align()
        pal = self.run_pal2nal()
        if not pal:
            return []
        self.process_pal2nal_get_cal_input(gene1, gene2)
        self.run_calculator()
        sequence_name, ka_value, ks_value, ka_ks_value = self.read_cal_result()
        return [ka_value, ks_value, ka_ks_value]

    def align(self):
        if self.align_software == 'mafft':
            command_line = [self.mafft, "--quiet", "--auto", self.pair_pep_file]
            try:
                with open(self.prot_align_file, 'w') as output_file:
                    subprocess.run(command_line, stdout=output_file, stderr=subprocess.DEVNULL, check=True)
            except subprocess.CalledProcessError:
                pass
        if self.align_software == 'muscle':
            command_line = [self.muscle, '-align', self.pair_pep_file, '-output', self.prot_align_file]
            try:
                subprocess.run(command_line, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            except subprocess.CalledProcessError:
                pass

    def run_pal2nal(self):
        command_line = [self.pal2nal, self.prot_align_file, self.pair_cds_file, '-output', 'paml', '-nogap']
        try:
            with open(self.pair_changed_seq, 'w') as output_file:
                subprocess.run(command_line, stdout=output_file, stderr=subprocess.DEVNULL, check=True)
        except subprocess.CalledProcessError:
            return None
        return True

    def run_yn00(self):
        command_line = [self.yn00]
        try:
            subprocess.run(command_line, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, check=True)
        except subprocess.CalledProcessError:
            pass

    def process_pal2nal_get_cal_input(self, gene1, gene2):
        cal_input = open(self.cal_input, "w")
        with open(self.pair_changed_seq) as pal_output:
            next(pal_output)
            first_line = ""
            second_line_id1 = ""
            third_line_id2 = ""
            flag1_seq = False
            flag2_seq = False
            contents = pal_output.readlines()
            for ele in contents:
                if ele.startswith(gene1):
                    first_line += gene1 + "_"
                    flag1_seq = True
                elif ele.startswith(gene2):
                    first_line += gene2
                elif flag1_seq and not flag2_seq:
                    second_line_id1 += ele.rstrip("\n")
                else:
                    third_line_id2 += ele.rstrip("\n")
            cal_input.write(first_line + "\n" + second_line_id1 + "\n" + third_line_id2 + "\n")


    def run_calculator(self):
        command_line = [self.KaKs_Calculator, "-i", self.cal_input, "-o", self.pair_cal, "-m", self.method]
        try:
            subprocess.run(command_line, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, check=True)
        except subprocess.CalledProcessError:
            pass

    def read_yn00_result(self):
        ng86 = dict()
        yn00 = dict()
        with open(self.pair_yn) as f:
            content = f.readlines()
            for line in content:
                if "(A) Nei-Gojobori (1986) method" in line:
                    a_index = content.index(line)
                if "(C) LWL85, LPB93 & LWLm methods" in line:
                    c_index = content.index(line)
            sub_content = content[a_index:c_index]
            for line in sub_content:
                # this regex is from biopython.
                matrix_row_res = re.match(r"^(\S+?)(\s+-?\d+\.\d+.*$|\s*$|-1.0000\s*\(.*$)", line)
                if matrix_row_res is not None:
                    line_floats_res = re.findall(r"-*\d+\.\d+", matrix_row_res.group(2))
                    line_floats = [float(val) for val in line_floats_res]
                    for i in range(0, len(line_floats), 3):
                        ng86["omega"] = line_floats[i]
                        ng86["dN"] = line_floats[i+1]
                        ng86["dS"] = line_floats[i+2]
                    continue

                row_res = re.match(r"\s+(\d+)\s+(\d+)", line)
                if row_res is not None:
                    line_floats_res = re.findall(r"-*\d+\.\d+", line)
                    line_floats = [float(val) for val in line_floats_res]
                    yn00["t"] = line_floats[2]
                    yn00["kappa"] = line_floats[3]
                    yn00["omega"] = line_floats[4]
                    yn00["dN"] = line_floats[5]
                    yn00["dS"] = line_floats[7]
        return ng86, yn00

    def read_cal_result(self):
        cal_result_df = pd.read_csv(self.pair_cal, sep="\t", header=0, index_col=None)
        sequence_name = cal_result_df.loc[0, "Sequence"]
        ka_value = cal_result_df.loc[0, "Ka"]
        ks_value = cal_result_df.loc[0, "Ks"]
        ka_ks_value = cal_result_df.loc[0, "Ka/Ks"]
        return sequence_name, ka_value, ks_value, ka_ks_value

    def get_thread(self):
        cpu_number = cpu_count()
        thread_number = min([self.process, cpu_number])
        setattr(self, 'process', thread_number)
    
    def output_file_parentdir_exist(self, path, overwrite):
        if os.path.exists(path):
            logger.info(f"Output file {path} already exist.")
            if overwrite:
                os.remove(path)
                logger.info(f"Output file {path} will be overwrote.")
                return
            else:
                if self.add_ks:
                    logger.info(f"Output file {path} will add extra syntenic pairs rather than overwrite it.")
                    return
                else:
                    logger.info(f"Output file {path} will not be overwrote, and you can set '--overwrite'/'--add_ks' in the command line to overwrite it or add extra syntenic pairs.")
                    sys.exit(1)
        path = os.path.abspath(path)
        dir_name = os.path.dirname(path)
        if os.path.isdir(dir_name):
            pass
        else:
            logger.info(f"{dir_name} does not exist and the software will recursively create the directory.")
            os.makedirs(dir_name, exist_ok=True)

    def ks_init(self):
        print()
        key_list = ["prot_align_file", "pair_changed_seq", "pair_yn", "pair_pep_file", "pair_cds_file",
                    "yn00_ctl", "mafft", "muscle", "pal2nal", "yn00", "work_dir"]
        for key, value in vars(self).items():
            if key != "conf" and key not in key_list:
                print(key, "=", value)
        print()

        base.file_empty(self.collinearity)
        cds_file_list = base.split_conf(self.cds_file, ",")
        for cds_fl in cds_file_list:
            base.file_empty(cds_fl)
        pep_file_list = base.split_conf(self.pep_file, ",")
        for pep_fl in pep_file_list:
            base.file_empty(pep_fl)
        self.output_file_parentdir_exist(self.ks_file, self.overwrite)

        self.get_thread()

        if os.path.exists("tmp"):
            shutil.rmtree('tmp')
        os.mkdir("tmp")

        return pep_file_list, cds_file_list

    @staticmethod
    def drop_duplicate_pair(pairs):
        allpairs = []
        pair_hash = set()
        for k in pairs:
            if k[0] == k[1]:
                continue
            elif k[0] + ',' + k[1] in pair_hash or k[1] + ',' + k[0] in pair_hash:
                continue
            else:
                pair_hash.add(k[0] + ',' + k[1])
                pair_hash.add(k[1] + ',' + k[0])
                allpairs.append(k)
        return allpairs

    def secondary_layer_run(self, pairs, i, cds, pep):
        os.chdir(os.path.join(self.work_dir, 'tmp', 'process_' + str(i)))
        process_sub_file = os.path.basename(self.ks_file) + "_" + str(i)
        process_sub_handle = open(process_sub_file, 'w')
        with open(self.yn00_ctl, 'w') as ctl:
            ctl.write("seqfile = " + self.pair_changed_seq + "\n" +
                      "outfile = " + self.pair_yn + "\n" +
                      "verbose = 1" + "\n" +
                      "icode = 0" + "\n" +
                      "weighting = 0" + "\n" +
                      "commonf3x4 = 0")
        if i == int(self.process) - 1:
            dt = datetime.datetime.now()
            time_now = dt.strftime('%Y/%m/%d %H:%M:%S')
            with alive_bar(len(pairs), title=f"[{time_now} INFO]", bar="bubbles", spinner="waves") as bar:
                for k in pairs:
                    SeqIO.write([cds[k[0]], cds[k[1]]], self.pair_cds_file, "fasta")
                    SeqIO.write([pep[k[0]], pep[k[1]]], self.pair_pep_file, "fasta")
                    kaks_list = self.pair_kaks(k[0], k[1])
                    if not kaks_list:
                        continue
                    process_sub_handle.write('\t'.join([str(i) for i in list(k)+kaks_list])+'\n')
                    bar()
                process_sub_handle.close()
        else:
            for k in pairs:
                SeqIO.write([cds[k[0]], cds[k[1]]], self.pair_cds_file, "fasta")
                SeqIO.write([pep[k[0]], pep[k[1]]], self.pair_pep_file, "fasta")
                kaks_list = self.pair_kaks(k[0], k[1])
                if not kaks_list:
                    continue
                process_sub_handle.write('\t'.join([str(i) for i in list(k)+kaks_list])+'\n')
            process_sub_handle.close()

    def first_layer_run(self):
        logger.info("ks module init and the following parameters are config information.")
        pep_file_list, cds_file_list = self.ks_init()
        cds = dict()
        pep = dict()
        for cds_fl in cds_file_list:
            sub_cds = SeqIO.to_dict(SeqIO.parse(cds_fl, "fasta"))
            cds.update(sub_cds)
        for pep_fl in pep_file_list:
            sub_pep = SeqIO.to_dict(SeqIO.parse(pep_fl, "fasta"))
            pep.update(sub_pep)
        df_pairs, _ = read_collinearity(self.collinearity)
        df_pairs = df_pairs[(df_pairs[0].isin(cds.keys())) & (df_pairs[1].isin(
            cds.keys())) & (df_pairs[0].isin(pep.keys())) & (df_pairs[1].isin(pep.keys()))]
        pairs = list(zip(df_pairs[0], df_pairs[1]))
        if len(pairs) > 0:
            pairs = self.drop_duplicate_pair(pairs)
        else:
            logger.error("Gene names do not match between collinearity file and cds/pep file.")
            sys.exit(1)
        if self.add_ks and os.path.exists(self.ks_file) and os.path.getsize(self.ks_file) > 0:
            ks_df = pd.read_csv(self.ks_file, header=0, index_col=None, sep="\t")
            ks_df['id1'] = ks_df['id1'].astype(str)
            ks_df['id2'] = ks_df['id2'].astype(str)
            used_pairs = list(zip(ks_df['id1'], ks_df['id2'])) + list(zip(ks_df['id2'], ks_df['id1']))
            retained_pairs = set(pairs).difference(set(used_pairs))
            pairs = np.array(list(retained_pairs))
            if len(pairs) == 0:
                logger.info("No additional syntenic pairs are required to calculate ks.")
                sys.exit(0)
        n = int(np.ceil(len(pairs) / self.process))
        os.chdir(os.path.join(self.work_dir, 'tmp'))
        pool = Pool(self.process)
        for i in range(self.process):
            os.mkdir('process_' + str(i))
            if i < self.process - 1:
                sub_pr = pairs[i * n:i * n + n]
            else:
                sub_pr = pairs[i * n:]
            pool.apply_async(self.secondary_layer_run, args=(sub_pr, i, cds, pep))
        pool.close()
        pool.join()
        logger.info(f'Combine the ks files generated by each kernel into {self.ks_file}.')
        os.chdir(self.work_dir)
        self.merge_ks_file()
        shutil.rmtree(os.path.join(self.work_dir, 'tmp'))
        logger.info(f"Generate {self.ks_file} done!")
