#!/bin/zsh
cd "/hb/CAE/PorousPipe00/PorousPipe01/sif/"
for i j
 in $(ls *.sif);
do
    echo $i:$j
    ElmerSolver $i &
    ElmerSolver $j 
    rm $i
    rm $j
    echo "*****"
done
