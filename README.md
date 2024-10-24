# HLA-EpiCheck

## Description

HLA-EpiCheck is a machine-learning project dedicated to the prediction of HLA epitopes on HLA antigens. The elements considered for training and prediction are 3D-surface patches computed from 3D structure of HLA antigens. 3D-surface patches are centered on a solvent-accessible residue and contain all other solvent-accessible residues on a distance of 15A from the center. 

Static and dynamic descriptors are defined and calculated for each 3D-surface patch. Dynamic descriptors are derived from 500 frames representing the last 5 ns of short molecular dynamics (MD) simulation runs (10 ns).

This repository contains all the scripts used for obtaining the results presented in a paper currently under evaluation:

Title: HLA-Epicheck: Efficient prediction of HLA B-cell epitopes using 3D-surface patch descriptors derived from molecular dynamic simulation.

## Content

- scripts : 

    * User_guide.ipynb: This notebook presents the procedure to follow in order to generate and use the ML descriptors defined in the HLA-EpiCheck paper. This procedure could be used to process new antigen data (new MD trajectories) or to reproduce the results obtained in the paper. 
    * compute_prepatches.tcl: This script is used to get the list of AAs within a radius of a given AA for each frame of the trajectory. Filtering the solvent-accessible AAs allow to get the solvent-accessible patches. For this porpose, median RSASA values are precomputed in the RSASA_median.txt file in each antigen folder. The usage is indicated in the header of the script.
    * dataset_gen_radius_15.ipynb: This notebook allows for the generation of the ML descriptors from patches of 15A radius presented in the HLA-EpiCheck paper. Please refer to the "User_guide.ipynb" notebook to learn how to use it.
    * pdb2fasta.sh: This is a support script used by the 'dataset_gen_radius_15.ipynb' notebook. It allows obtaining the AA sequence of a PDB structure.
    * RMSF.tcl: This is a support script used by the 'run_batch_RMSF.sh' script to calculate the RMSF of a MD trajectory.
    * RSASA_trajectory.py: This script allows for the calculation of RSASA values for a set of MD trajectories. Its usage is explained in the 'User_guide.ipynb' notebook.
    * run_batch_RMSF.sh and run_vmd_RMSF.sh: These scripts allow for the calculation of RMSF values for a set of MD trajectories. Their usage is explained in the 'User_guide.ipynb' notebook.
    * SASA_compute_trajectory.tcl: This is a support script used by the 'RSASA_trajectory.py'. It allows for the calculations of SASA values.

- ML_models : models trained using the entire corresponding dataset (redundant or non-redundant). The model files were generated using pickle 4.0 and scikit-learn 1.2.2. Their use is introduced in the notebook 'User_guide.ipynb'.

- data: 

    * All_confirmed_eplets.csv, All_non_confirmed_eplets.csv, list_All_confirmed_eplets.csv and list_All_non_confirmed_eplets.csv: These files contain the definition of all eplets reported in the HLA Eplet Registry.
    * A_nr_results.txt, B_nr_results.txt, C_nr_results.txt, DPA1_nr_results.txt, DPB1_nr_results.txt, DQA1_nr_results.txt, DQB1_nr_results.txt DRA_nr_results.txt and DRB_nr_results.txt: These files contain the AA sequences of HLA alleles reported in the IPD-IMGT/HLA database.
    * DB_clu_0.9_all.tsv: This file contains the sequence clustering obtained using MMseqs2.
    * descriptors_all_patches_radius_15.csv: This file contains the descriptors of all the patches computed.
    * descriptors_non_confirmed_eplets.csv: This file contains the descriptors of all patches assotiated to non-confirmed eplets.
    * descriptors_patches_non-redundant_radius_15.csv: This file contains the descriptors used for the training ML models when removing the sequence redudancy in the dataset (90% identity threshold).
    * descriptors_patches_training-test_radius_15.csv: This file contains the descriptors used for the training of ML models when keeping the sequence redudancy in the dataset.
    * general_min.conf and general_MD.conf: These files contain the parameters used for running the minimisation and MD simulation on NAMD3.
    * Max_SASA_per_residue.tsv: This file contains the maximum SASA values of AAs reported in 'Tien, M.Z. et al. Maximum Allowed Solvent Accessibilites of Residues in Proteins. PLOS ONE. 2013. https://doi.org/10.1371/journal.pone.0080635'.
    * precomputed_HLA-EpiCheck.zip: This file contains precomputed data that can be used to run the notebook 'dataset_gen_al_radius_15.ipynb'. Due to its size, it must be downloaded from the following link: https://drive.google.com/file/d/1HfPxQqbpMi7uh497Ean9JqKg3MzIGaaw/view?usp=sharing.
    
        Data is organised by locus and antigens. In each antigen folder, four types of data can be found :

        + patchs : This folder contains the prepatches computed with the script compute_prepatches.tcl. Each file contains the prepatches for a given residue and patch size (see file name). The format used in each file is as follows: each line corresponds to a prepatch and contains two colon-separated entries. The first one corresponds to a space-separated list the residues that compose the prepatch and the second one corresponds to the PDB frame from which the prepatch was extracted.
    	+ PDBs : This folder contains the PDB files used for computing the prepatches and SASA data.
    	+ SASAs_out : This folder contains the SASA values computed for each PDB frame (i.e. a SASA file per frame). The format used in each file is as follows: each line corresponds to an AA and contains the AA number (enumeration starts at 0) and the corresponding SASA value.
    	+ RSASA_median.txt :  This file contains the median RSASA computed for each AA along the trajectory. The format used in each file is as follows: each line corresponds to an AA and contains the AA number (enumeration starts at 0) and the corresponding RSASA value.

    * table_patchID_antigen_resid_radius_15.csv: This file contains the antigen and resid associeted to each patch_ID.

## Usage

The notebook 'User_guide.ipynb' in the 'scripts' folder presents the procedure to follow in order to generate and use the ML descriptors defined in the HLA-EpiCheck paper. This procedure could be used to process new antigen data (new MD trajectories) or to reproduce the results obtained in the paper. 

## Contact

Diego Amaya ramirez <diego.amaya-ramirez@inria.fr> 

## Authors

Diego Amaya-Ramirez [1] ,Magali Devriese [2], Romain Lhotte [2], Cedric Usureau [2], Malika Smaıl-Tabbone [1], Jean-Luc Taupin [2] and Marie-Dominique Devignes [1].

[1] LORIA, Université de Lorraine, CNRS, INRIA, Nancy, 54000, France

[2] Hôpital Saint-Louis, Inserm, Paris, 75010, France

## Acknowledgment

Diego Amaya-Ramirez benefited from an Inria-Inserm PhD fellowship. This work was supported in part by the "Agence Nationale pour la Recherche (ANR)": project ANR-22-CE15-0036, and by the "Société Française de Transplantation".

Experiments presented in this paper were carried out using the Grid'5000 testbed, supported by a scientific interest group hosted by Inria and including CNRS, RENATER and several Universities as well as other organizations (see https://www.grid5000.fr), as well as the MBI-DS4H platform hosted by Inria/Loria and funded by CPER IT2MP (Contrat Plan État Région, Innovations, Technologiques, Modélisation \& Médicine Personalisée), including a FEDER co-funding.

## License
MIT license


Copyright 2024 INRIA

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

