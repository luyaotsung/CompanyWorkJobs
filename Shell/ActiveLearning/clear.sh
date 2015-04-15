#!/bin/bash

## $1 = Input files 
Target_File=$1

sed 's/\t\+\t/ /g' $Target_File > /tmp/1
sed 's/\t/ /g' /tmp/1 > /tmp/2
sed 's/ \+ / /g' /tmp/2 > /tmp/3 
sed 's/[ \t]*$//' /tmp/3 > /tmp/4  
sed 's/ /\t/g' /tmp/4 > $Target_File
