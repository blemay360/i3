#!/bin/bash
filename=classSchedule.txt
date=$(date)
while read -r line
do
	line="$line"
	if [ ${date::3} = ${line::3} ]; then
		rough=$line
	fi
done < "$filename"
rough=${rough:4}
tmp=${rough##.}
firstClass=${rough%.*}
secondClass=${rough#*.}
IFS=, read -r -a firstClass <<< "$firstClass"
IFS=, read -r -a secondClass <<< "$secondClass"

tmp=${date%:??' EST'*}
len=${#tmp}
time=${tmp:len-6}
hours=${time:1:2}
minutes=${time:4}
time=$[hours*60+minutes]

tmp=$((${firstClass[0]}))
firstClassHour=${tmp::2}
firstClassMinute=${tmp:2}
firstClassTime=$[firstClassHour*60+firstClassMinute]

tmp=$((${secondClass[0]}))
secondClassHour=${tmp::2}
secondClassMinute=${tmp:2}
secondClassTime=$[secondClassHour*60+secondClassMinute]

function nextClass {
	if [ $time -lt $firstClassTime ]; then
		nextClass=${firstClass[1]}
		nextTime=${firstClassTime}
	elif [ $time -gt $firstClassTime ] && [ $time -lt $secondClassTime ]; then
		nextClass=${secondClass[1]}
		nextTime=${secondClassTime}
	else
		nextClass="error in nextClass"
		nextTime="error in nextClass"
	fi
}

function difference {
	difference=$[$nextTime-$time]
	remainingMin=$[difference % 60]
	if [ ${#remainingMin} = 1 ]; then
		remainingMin=0$remainingMin
	fi
	remainingHour=$[difference / 60]
	echo $remainingHour':'$remainingMin
}
nextClass
difference
