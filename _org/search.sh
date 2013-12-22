#! /bin/bash
test -e newdata.dat && cat newdata.dat >> database.dat && rm newdata.dat
sed 's/\([^ ]*\) \([^ ]*\) \([ 0]*\)$/0 \1 \2 \3/' database.dat | sed 's/ \([^ ]\)\([^0-9]\)/ 0\1\2/g' | sed 's/ \([^ ]\)\([^0-9]\)/ 0\1\2/g'| sed 's/^\([^ ]\)\([^0-9]\)/0\1\2/g'| sed 's/ \([0-9][0-9]\) / \1.00 /g' | sed 's/ \([0-9][0-9]\) / \1.00 /g' | sed 's/^\([0-9][0-9]\) /\1.00 /g' | sort -n | sed 's/ 0\([^ ]\)/  \1/g' | sed 's/\.00 /    /g' | sed 's/^0/ /g' | sed '/^ *0/d' > binsearch.dat
