cd "/hb/CAE/PorousPipe00/PorousPipe01/sif/"
for f in $(ls *.sif);do
    ElmerSolver $f
done
