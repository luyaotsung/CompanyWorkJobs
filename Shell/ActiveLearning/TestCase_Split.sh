#!/bin/bash


# ARGV1 => testcase file
# Argv2 => split number

CaseFile=$1
SplitNumber=$2

LineOne=`head -1 $CaseFile`
TotalCaseNumber=`cat $CaseFile | wc -l `

NewFileLineCount=$(((TotalCaseNumber/SplitNumber)+1))
echo "New File Line Count $NewFileLineCount"
linecount=0
filecount=1
NewFileName="$TotalCaseNumber-$SplitNumber-$filecount"."txt"
while read LINE
do 
    
    if test $linecount -eq "1"
    then
        NewFileName="$TotalCaseNumber-$SplitNumber-$filecount"."txt"
        touch $NewFileName
        #echo $LINE > $NewFileName
        #echo $LineOne > $NewFileName
    fi
    echo $LINE >> $NewFileName

    linecount=$((linecount+1))
    if test $linecount -eq $NewFileLineCount 
    then
        linecount=0
        filecount=$(($filecount+1))
    fi
done < "$CaseFile"


