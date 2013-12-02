#! /bin/bash


sed 's/ \([^ ]\)\([^0-9]\)/ 0\1\2/g' database.dat | sed 's/ \([^ ]\)\([^0-9]\)/ 0\1\2/g'| sed 's/^\([^ ]\)\([^0-9]\)/0\1\2/g'| sed 's/ \([0-9][0-9]\) / \1.00 /g' | sed 's/ \([0-9][0-9]\) / \1.00 /g' | sed 's/^\([0-9][0-9]\) /\1.00 /g' | sort -n | sed 's/ 0\([^ ]\)/  \1/g' | sed 's/\.00/   /g' | sed 's/^0/ /g' > temp
sed '/^ *0/d' temp > binsearch.dat
rm temp
