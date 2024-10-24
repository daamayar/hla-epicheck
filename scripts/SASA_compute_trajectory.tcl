set allsel [atomselect top "all"]
set numframes [molinfo top get numframes]
for {set i 0} {$i < $numframes} {incr i} {
  $allsel frame $i
  set residlist [lsort -unique [$allsel get residue]]
  set filename SASAs_out/SASA_$i.txt 
  set fileID [open $filename "w"]
  foreach r $residlist {
    set sel [atomselect top "residue $r"]
    set sasa [measure sasa 1.4 $allsel -restrict $sel]
    #set res [lsort -unique [[atomselect top  "residue $r" frame $i] get resname]]
    #$sel set user $rsasa
    #$sel delete
    #puts "residue\t$r,\tsasa\t$sasa"
    set data "$r\t$sasa\n"
    puts -nonewline $fileID $data
    $sel delete
  } 
  close $fileID
}

