import argparse
import control_corr
import process_raw_boxplot
import sys


def check_column_value(par):
    if par.sheet_name == 'root' and par.column not in ['d1', 'd2', 'd3']:
        print("Error: When --root_or_shoot is 'root', --column should be one of 'd1', 'd2', 'd3'")
        sys.exit(1)
    elif par.sheet_name == 'shoot' and par.column not in ['u1', 'u2', 'u3']:
        print("Error: When --root_or_shoot is 'shoot', --column should be one of 'u1', 'u2', 'u3'")
        sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Correlation analysis based on shuffle gene pairs for maize sorghum and wheat')

    subparsers1 = parser.add_subparsers(title='correlation analysis', dest='corr_analysis')
    # subparser corr analysis

    parser_sub1 = subparsers1.add_parser('bootstrap_corr', help='bootstrap gene pair corr analysis')
    parser_sub1.add_argument("-t", "--table_file", dest="table_file", type=str, default="",
                             help="table_file(filtered blast) by quota_Anchor")
    parser_sub1.add_argument("-W", "--collinearity", dest="collinearity", type=str, default="", help="collinearity file by quota_Anchor")
    parser_sub1.add_argument("-W1", "--collinearity_total", dest="collinearity_total", type=str, default="",
                             help="collinearity file by quota_Anchor(-a 1)")
    parser_sub1.add_argument("-e", "--expression", dest="expression", type=str, default="", help="gene expression matrix file")
    parser_sub1.add_argument("-co", "--corr", dest="corr", type=str, default="result.csv", help="corr result file")
    parser_sub1.add_argument("-m", "--method", dest="method", type=str, default="spearman", choices=["pearson", "spearman"], help="pearson or spearman")
    parser_sub1.add_argument("-c", "--column", dest="column", type=str, default="", choices=["d1", "d2", "d3", "u1", "u2", "u3"],
                             help="e.g.typing d1 or d2 or d3 for root and typing u1 or u2 or u3 for shoot")
    parser_sub1.add_argument("-b", "--bool", dest="bool_log", type=str, default="T", help="default log2(tpm+1) if set F using tpm")
    parser_sub1.add_argument("-B", "--Block_min", dest="Block_min", type=int, default="10",
                             help="using this value to restrict minimum block length for correlation analysis(default: 10) ")
    parser_sub1.add_argument("-s", "--sheet_name", dest="sheet_name", type=str, default="shoot", choices=["shoot", "root"],
                             help="xlsx expression file sheet name ? (shoot or root default：shoot)")
    parser_sub1.add_argument("-boot", "--bootstrap", dest="bootstrap", type=int, default="10000",
                             help="random sampling number from gene pair set")
    parser_sub1.add_argument("-sample_size", "--sample_size", dest="sample_size", type=int, default="30",
                             help="sample size")
    parser_sub1.add_argument("-sheet_prefix", "--sheet_prefix", dest="sheet_prefix", type=str, default="YM_GL",
                             help="YM_GL, YM_ZGC, GL_ZGC")
    parser_sub1.set_defaults(func=control_corr.block_total_corr)

    # subparser corr analysis process csv file to R input
    parser_sub2 = subparsers1.add_parser('process', help='process csv file to R boxplot_violin input')
    parser_sub2.add_argument("-i", "--input_file", dest="input", type=str, default="", help="six columns csv format file ")
    parser_sub2.add_argument("-o", "--output_file", dest="output", type=str, default="", help="boxplot_violin plot input file")
    parser_sub2.set_defaults(func=process_raw_boxplot.process)

    args = parser.parse_args()
    if hasattr(args, 'func'):
        if args.corr_analysis == "bootstrap_corr":
            check_column_value(args)
        args.func(args)
    else:
        parser.print_help()
