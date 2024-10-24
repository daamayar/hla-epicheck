# USAGE : vmd -dispdev text -e compute_patches.tcl -args <data_directory> <patch_size>
# <data_directory> corresponds to the absolute path to the directory that contains the antigen directories which contain the data to be processed.
# <patch_size> corresponds to the size of the patches to be computed.

set dir_PDBs [lindex $argv 0]
set patch_size [lindex $argv 1]
catch {cd $dir_PDBs}
catch {mkdir -p ../patchs}
exec ls {*}[glob *.pdb] > list_pdbs.txt
set frame_0 [exec ls {*}[glob *frame_0.pdb]]
set mol_0 [mol new $frame_0 type pdb waitfor all]
set allsel [atomselect $mol_0 "protein"]
set len [llength [lsort -unique [$allsel get residue]]]
$mol_0 delete
$allsel delete
set file_pdbs [open list_pdbs.txt r]
set pdbs [read -nonewline $file_pdbs]
close $file_pdbs
set list_pdbs [split $pdbs "\n"]

for {set i 1} {$i <= $len} {incr i} {
    set file_out [open "../patchs/patches_vmd_resid_${i}_size_${patch_size}.txt" "w"]
    foreach pdb $list_pdbs {
        set mol [mol new $pdb type pdb waitfor all]
        set sel_resids [atomselect $mol "protein and same residue as within $patch_size of resid $i"]
        set list_resids [lsort -unique [$sel_resids get resid]]
        $sel_resids delete
        set center_sel [atomselect $mol "protein and resid $i"]
        set center_COM [measure center $center_sel weight mass]
        $center_sel delete
        set list_COM ""
        foreach resi $list_resids {
            set resid_sel [atomselect $mol "protein and resid $resi"]
            set resid_COM [measure center $resid_sel weight mass]
            set dist [veclength [vecsub $center_COM $resid_COM]]
            $resid_sel delete
            if {$dist <= $patch_size} {
                lappend list_COM $resi
            }
        }
        mol delete $mol
        puts -nonewline $file_out "$list_COM:$pdb\n"
    }
    close $file_out
}
exit
