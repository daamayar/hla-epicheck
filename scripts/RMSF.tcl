# USAGE : vmd -dispdev text -e RMSF.tcl -args psf1 dcd1 output_name

set psf1 [lindex $argv 0]
set dcd1 [lindex $argv 1]
set name [lindex $argv 2]
set n_frames [lindex $argv 3]

set outfile [open $name.dat w]

set mol [mol new $psf1 type psf waitfor all]
mol addfile $dcd1 type dcd  waitfor all

set ref [atomselect top "protein and noh" frame 0]
set sel [atomselect top "protein and noh"]
for { set f 0 } { $f < $n_frames } { incr f } {
$sel frame $f
$sel move [measure fit $sel $ref]
}

set sel1 [atomselect top "protein and noh and chain A"]
set resids [$sel1 get residue]
set uniqueresids_A [lsort -unique -integer $resids]
set count 1
foreach resid $uniqueresids_A { 
    set ressel [atomselect top "protein and residue $resid"]
    set value [vecmean [measure rmsf $ressel]]
    puts $outfile "$count\t$value"
    set count [expr $count+1]
    $ressel delete
} 

set sel2 [atomselect top "protein and noh and chain B"]
set resids [$sel2 get residue]
set uniqueresids_B [lsort -unique -integer $resids]
foreach resid $uniqueresids_B {
    set ressel [atomselect top "protein and residue $resid"]
    set value [vecmean [measure rmsf $ressel]]
    puts $outfile "$count\t$value"
    set count [expr $count+1]
    $ressel delete
} 

close $outfile

exit
