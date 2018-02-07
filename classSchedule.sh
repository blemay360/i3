#!/bin/bash
filename=~/.i3/classSchedule.txt
rough=$(cat $filename)
function makeArray {
	numClasses=0
	while [ ${#rough} -gt 1 ]; do
		class[$numClasses]=${rough%%=*}
		rough=${rough#*=}
		let numClasses=$numClasses+1
	done
}

function orgArray {
	counter=0
	while [ $counter -lt $numClasses ]; do
		remainder=$[counter % 3]
		classNum=$[counter / 3]
		if [ $remainder -eq 0 ]; then #time
			time[$classNum]=${class[$counter]}
			time[$classNum]=$(convertTime ${time[$classNum]})
		elif [ $remainder -eq 1 ]; then #name
			name[$classNum]=${class[$counter]}
		elif [ $remainder -eq 2 ]; then #room
			room[$classNum]=${class[$counter]}
		fi
		let counter=$counter+1
	done
}

function convertTime {
	input=$1
	if [ ${#input} -lt 1 ]; then
		input=$(currentTime)
	fi
	hours=${input%:??}
	minutes=${input#??:}
	time=$[10#$hours*60+10#$minutes]
	echo $time
}

function currentTime {
	date="$(date)"
	tmp=${date%:??' EST'*}
	len=${#tmp}
	time=${tmp:len-6}
	echo $time
}

function getAscendingTime {
	counter=1
	while [ $counter -le $[classNum] ]; do
		previous=$[counter-1]
		while [ ${time[$previous]} -gt ${time[$counter]} ]; do
			let time[$counter]=${time[$counter]}+1440
		done
		let counter=$counter+1
	done
}

function getTime {
	time=$(convertTime)
	date="$(date)"
	counter=0
	for i in Mon Tue Wed Thu Fri Sat Sun; do
		if [ ${date::3} = $i ]; then
			let time=$time+1440*$counter
		fi
		let counter=$counter+1
	done
	echo $time
}

function getDifference {
	counter=0
	while [ $counter -le $[classNum] ]; do
		if [ $(getTime) -lt ${time[$counter]} ]; then
			echo $[${time[$counter]}-$(getTime)]
			return
		fi
		let counter=$counter+1
	done
}

function main {
	makeArray
	orgArray
	getAscendingTime 
	difference=$(getDifference)
	echo $[difference/60]:$[difference%60] 
}

main
