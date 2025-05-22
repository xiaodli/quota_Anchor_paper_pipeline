from process_file import tuple_ele_list_to_two_list
from scipy.stats import pearsonr, ConstantInputWarning, spearmanr, PermutationMethod
import warnings
warnings.filterwarnings('error', category=ConstantInputWarning)


def size_corr(same_or_inv_ele_tuple, method):
    dict_corr = {}
    index = 1
    for corr in same_or_inv_ele_tuple:
        if len(corr) >= 30:
            query_list, ref_list = tuple_ele_list_to_two_list(corr)
            assert len(query_list) == len(ref_list)
            if method == "pearson":
                try:
                    correlation_coefficient, p_value = pearsonr(query_list, ref_list)
                    if p_value < 0.05:
                        dict_corr[index] = correlation_coefficient
                        index += 1
                except ConstantInputWarning:
                    print("pearsonr don't agree with constant input,in other words query block or ref block expression sum is zero.")
            else:
                try:
                    correlation_coefficient, p_value = spearmanr(query_list, ref_list)
                    if p_value < 0.05:
                        dict_corr[index] = correlation_coefficient
                        index += 1
                except ConstantInputWarning:
                    print("pearsonr don't agree with constant input,in other words query block or ref block expression sum is zero.")
    return dict_corr
