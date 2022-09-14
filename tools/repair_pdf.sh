FILES="*.pdf"
for f in $FILES
do
    pdfseparate -f 1 -l 1 $f $(echo $f | sed s/.pdf/.new.pdf/)
    rm $f
    mv $(echo $f | sed s/.pdf/.new.pdf/) $f
done
