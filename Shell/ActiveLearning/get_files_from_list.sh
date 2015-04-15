#!/bin/bash 

File_List=$1
Source=$2
Target=$3

while read line 
do 
    echo $line 
    cp $Source"/"$line  $Target
done < "$File_List"
