#!/bin/bash

meep del=$1 waveguide.ctl  >& foo.out

#head --lines=-3 foo.out | sed '1,12d' > vals.csv

head -n -3 foo.out | tail -n +12 > vals.csv

#awk '{ sum1 += $1; sum2 += $2; sum3 += $3; n++ } END { if (n > 0) print sum1 / n; print sum2 / n; print sum3 / n; print (n * (sum3)/(sum1*sum2))}' vals.csv

awk '{ sum1 += $1; sum2 += $2; sum3 += $3; n++ } END { if (n > 0) print (n * (sum3)/(sum1*sum2))}' vals.csv
