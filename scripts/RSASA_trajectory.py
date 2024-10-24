''''
USAGE : python RSASA_trajectory.py <data_directory>

<data_directory> corresponds to the absolute path to the directory that contains the antigen directories which contain the data to be processed.

Run the script from the same directory where it is located.

Attention! This script requires the python package 'VMD-PYTHON'.
'''


import pandas as pd
import os
import subprocess
import sys

import time
import traceback
from joblib import Parallel, delayed
import multiprocessing as mp


def RSASA_compute(directory, CWD):
    from vmd import evaltcl
    from vmd import molecule
    from vmd import atomsel
    start = time.time()
    os.chdir(f'{directory}')
    trajectory = subprocess.check_output('ls *dcd', shell=True)
    trajectory = trajectory.decode('utf-8').strip()
    topology = subprocess.check_output('ls *.psf', shell=True)
    topology = topology.decode('utf-8').strip()
    max_sasa = pd.read_csv(f'{CWD}/../data/Max_SASA_per_residue.tsv', header=None, sep='\t')
    dic = {
            'GLY': 'G',
            'ALA': 'A',
            'VAL': 'V',
            'PHE': 'F',
            'PRO': 'P',
            'MET': 'M',
            'ILE': 'I',
            'LEU': 'L',
            'ASP': 'D',
            'GLU': 'E',
            'LYS': 'K',
            'ARG': 'R',
            'SER': 'S',
            'THR': 'T',
            'TYR': 'Y',
            'HIS': 'H',
            'CYS': 'C',
            'ASN': 'N',
            'GLN': 'Q',
            'TRP': 'W',
            'HSD': 'H'
    }
    os.system(f'mkdir SASAs_out')
    pdbid = molecule.load('psf', f'{topology}', 'dcd', f'{trajectory}')
    evaltcl(f'source {CWD}/SASA_compute_trajectory.tcl')

    list_SASA_files = subprocess.check_output('ls ./SASAs_out/SASA*txt', shell=True)
    num_frames = len(list_SASA_files.decode('utf-8').split('\n')) - 1
    SASA_df = pd.DataFrame(columns=[f'frame_{i}' for i in range(num_frames)])
    for i in range(num_frames):
        SASA_file = pd.read_csv(f'./SASAs_out/SASA_{i}.txt',
                                usecols=[0, 1],
                                names=[0,1],
                                header=None,
                                sep='\t',
                                low_memory=False,
                                dtype={
                                    0: 'int32',
                                    1: 'float64'
                                })
        SASA_file = SASA_file.sort_values(by=[0]).reset_index(drop=True)
        SASA_df[f'frame_{i}'] = SASA_file[1]

    SASA_df['median'] = SASA_df.median(axis=1)
    SASA_df['median'].to_csv('SASA_median.txt', sep='\t')
    SASA_df_median = pd.DataFrame()
    SASA_df_median['median'] = SASA_df['median']
    RSASA_df = pd.DataFrame()

    for index, row in SASA_df_median.iterrows():
        resname = evaltcl(
                f'set res  [[atomselect top  "residue {index}"] get resname]'
        )
        res = dic[resname[:3]]
        RSASA_df.loc[index, 'RSASA'] = (
            row.iloc[0] / max_sasa.loc[max_sasa[0] == res].iloc[0, 3]) * 100

    molecule.delete(pdbid)
    RSASA_df.to_csv('RSASA_median.txt', sep='\t')
    return f'walltime : {time.time() - start}'

if __name__ == '__main__':
    try:
        dir_data = sys.argv[1]
        os.system(f'ls -d {dir_data}/*/ > {dir_data}/list_antigens.txt')
        CWD = os.getcwd()

        list_dirs = []

        with open(f'{dir_data}/list_antigens.txt', 'r') as f1:
            list_dirs = list_dirs + [line.strip()[:-1] for line in f1]

        out = Parallel(n_jobs=int(mp.cpu_count()-4))(delayed(RSASA_compute)(directory, CWD) for directory in list_dirs)
        
    except:
        traceback.print_exc()
        sys.exit(1)
