import configparser
import logging
import argparse
from pathlib import Path
import os
import sys
import ks, base

base_dir = Path(__file__).resolve().parent

def run_ks(parameter):
    global base_dir
    config_par = configparser.ConfigParser()
    if parameter.conf is not None:
        base.file_empty(parameter.conf)
        config_par.read(parameter.conf)
    config_soft = configparser.ConfigParser()
    config_soft.read(os.path.join(base_dir, 'software_path.ini'))
    ks.Ks(config_par,config_soft, parameter).first_layer_run()

parser = argparse.ArgumentParser(description='Conduct strand and WGD aware syntenic gene identification for a pair of genomes using the longest path algorithm implemented in AnchorWave.', prog="quota_Anchor")
parser.add_argument('-v', '--version', action='version', version='%(prog)s 0.0.1')


subparsers = parser.add_subparsers(title='Gene collinearity analysis', dest='analysis')

parser_sub_ks = subparsers.add_parser('ks',
                                      help='Synonymous/non-synonymous substitution rates for syntenic gene pairs calculated in parallel.',
                                      formatter_class=argparse.RawDescriptionHelpFormatter, description="""                                           
    You can execute this command in three ways: 

    1. Using configuration file:
       a)quota_Anchor ks -c [\\?, example, help] >> ks.conf 
       b)quota_Anchor ks -c ks.conf [--overwrite] 

    2. Using command-line arguments:
       quota_Anchor ks -a mafft -i sb_zm.collinearity -p sb_zm.pep.fa
                                           -d sb_zm.cds.fa -o sb_zm.ks -t 6 [--overwrite] [--add_ks] 
       quota_Anchor ks -a muscle -i zm_zm.collinearity -p zm.pep.fa
                                           -d zm.cds.fa -o zm_zm.ks -t 6[--overwrite] [--add_ks]                                
    3. Using both a configuration file and command-line arguments:
       The configuration file has lower priority than other command-line parameters. 
       Parameters specified in the configuration file will be replaced by those provided via the command line.

       quota_Anchor ks -c ks.conf -a mafft -i sb_zm.collinearity -p sb_zm.pep.fa
                                           -d sb_zm.cds.fa -o sb_zm.ks -t 6[--overwrite] [--add_ks]
 """)
parser_sub_ks.set_defaults(func=run_ks)
parser_sub_ks.add_argument('-c', '--conf', dest='conf', help="Configuration files have the lowest priority.",
                           metavar="")
parser_sub_ks.add_argument('-i', '--collinearity', dest='collinearity', help="Collinearity file.", metavar="")
parser_sub_ks.add_argument('-a', '--align_software', dest='align_software',
                           help="Align software for every syntenic gene pair(muscle/mafft).",
                           choices=["mafft", "muscle"], metavar="")
parser_sub_ks.add_argument('-p', '--pep_file', dest='pep_file', help="Species longest protein sequence file(Separator: ',').",
                           metavar="")
parser_sub_ks.add_argument('-d', '--cds_file', dest='cds_file', help="Species longest cds sequence file(Separator: ',').", metavar="")
parser_sub_ks.add_argument('-o', '--ks_file', dest='ks_file', help="Output ks file.", metavar="")
parser_sub_ks.add_argument('-t', '--process', dest='process', help="Number of parallel processes.", metavar="",
                           type=int)
parser_sub_ks.add_argument('-m', '--method', dest='method', help="Method for kska calculator", metavar="",
                           type=str)
parser_sub_ks.add_argument('-add_ks', '--add_ks', dest='add_ks', help="Add extra syntenic pairs rather than overwrite it",
                           action='store_true')
parser_sub_ks.add_argument('-overwrite', '--overwrite', dest='overwrite', help="Overwrite the output file.",
                           action='store_true')

args = parser.parse_args()

def main():
    # Namespace(analysis='col', conf=None, input_file=None, output_file=None, r_value=None, q_value=None, 
    # strict_strand=None, get_all_collinearity=None, count_style=None, 
    # tandem_length=None, over_lap_window=None, maximum_gap_size=None, func=<function run_coll at 0x7fe24640d620>)
    logger = logging.getLogger('main')
    logger.setLevel(level=logging.INFO)
    # logging.basicConfig(level=logging.INFO,
    #                    datefmt='%Y/%m/%d %H:%M:%S',
    #                    format='[%(asctime)s - %(name)s - %(levelname)s - %(lineno)d] - %(module)s - %(message)s')
    logging.basicConfig(level=logging.INFO,
                        # filename='output.log',
                       datefmt='%Y/%m/%d %H:%M:%S',
                       format='[%(asctime)s %(levelname)s] %(message)s')
    if hasattr(args, 'func'):
        print_help_condition = True
        for key, value in vars(args).items():
            if key != "func" and key != "analysis" and value is not None and value != False:
                print_help_condition = False
                break
        if args.conf is None and print_help_condition:
            subparsers.choices[args.analysis].print_help()
        else:
            args.func(args)
    else:
        parser.print_help()
        sys.exit(0)

if __name__ == '__main__':
    main()