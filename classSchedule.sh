#!/bin/bash
filename=classSchedule.txt
date=$(date)
date=${date::3}
while read -r line
do
	line="$line"
	if [ $date = ${line::3} ]; then
		rough=$line
	fi
done < "$filename"
rough=${rough:4}
echo $rough
for i in {$#rough}; do
	echo $i
done
