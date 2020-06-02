#!/bin/bash


#The purpose of this script is to generate CPU load.  It downloads the bible as a text file and splits every word onto it's own line
# Each of these lines is hashed to cause CPU load

#Tweak these variables as you'd like
sampleRate=.2  # How many words will we actually hash?
inputFileURL=https://raw.githubusercontent.com/mxw/grmr/master/src/finaltests/bible.txt


# Is last invocation still running?
pidFileName=/tmp/loadgen-pid.txt
lastPID=$(< ${pidFileName})

if [[ ! -z "${lastPID}" ]] && [[ $(ps ${lastPID} | wc -l) -ne 1 ]]  # wc still returns 1 line if the process doesn't exist (headers)
	then
		echo "The previous pid [${lastPID}] is still running.  The program will exit"
		exit
	fi
thisPID=$$
echo ${thisPID} > ${pidFileName}


# Handle remaining variables
wordFile=/tmp/words.txt
hashedWordFile=${wordFile}.hashed
totWords=$(curl ${inputFileURL} | tr ' ' '\n' | wc -l)
currHour=$(date +%l)  #hour 1-12.  If we are tricky, we can make use of this to cause a histogram in our load
desiredPercentage=$(awk "BEGIN {printf \"%.2f\n\", ${currHour}/12}")
desiredWords=$(awk "BEGIN {printf \"%.0f\n\", ${totWords} * ${desiredPercentage} * ${sampleRate}}")
hashProgram=sha1sum  # On Mac this is different

# Override hash program to pipe into in case we are working on a Mac
if [[ $(uname) = "Darwin" ]]; then hashProgram="shasum -a 1"; fi  

# Print runtime params
echo hashProgram = ${hashProgram}
echo thisPID = ${thisPID}
echo pidFileName = ${pidFileName}
echo totWords = ${totWords}
echo currHour = ${currHour}
echo desiredPercentage = ${desiredPercentage}
echo sampleRate = ${sampleRate}
echo desiredWords = ${desiredWords}


# Create temp file
curl ${inputFileURL} | tr ' ' '\n' > ${wordFile}  

# Hash the first N words in the temp file.
for w in $(cat ${wordFile} | head -n ${desiredWords}); do echo $w | ${hashProgram} ; done | tee ${hashedWordFile}
