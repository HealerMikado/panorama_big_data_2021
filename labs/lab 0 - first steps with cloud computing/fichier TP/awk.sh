for year in ncdc_data/*
do
    printf "base year $year.gz \t"
    # readind while ungziping
    # | means "pipe", the output of the first instruction is the input of the second
    # for each line in the file :
    # - extract temperature and quality, then simple a simple test
    gunzip -c $year |\
        awk '{temp=substr($0, 88, 5)+0;
        q=substr($0, 93 , 1);
        if (temp!=9999 && q~/[01459]/&& temp>max) max = temp}
        END {print max}'
done