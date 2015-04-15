#!/bin/bash

Path=$1
Device=$2
Target_Path=$3

TMP_Name="/tmp/sort.list.$Device"
Sort_File="sort.done.list.$Device"

`find $Path -name "*.jpg" > $TMP_Name  && cat $TMP_Name | sort > $Sort_File`

while read line 
do 
    echo $line
    Erase_Path=$Target_Path"/*"
    #adb -s $Device shell "rm -rf $Erase_Path"
    adb -s $Device push $line $Target_Path

done < "$Sort_File"
