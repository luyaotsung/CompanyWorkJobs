#!/bin/bash 

F_array=( Each_01 Each_02 Each_03 Each_04 Each_05 Each_06 Each_07 Each_08 Each_09 Each_10 )

if [ ! -d TMP ]
then 
    echo "Create TMP"
    mkdir TMP
else 
    echo "Delete TMP & Careate new one "
    rm -rf TMP
    mkdir TMP
fi 

index=1

for f_name in "${F_array[@]}"
do 
    
    `find $f_name  -name *.jpg > /tmp/$f_name `    
    mkdir -p "TMP/"`printf "%02d\n" $index`  
    
    while read line 
    do 
        cp -Rvpf $line TMP/`printf "%02d\n" $index` 
    done < "/tmp/$f_name"

    index=$(($index+1))
done 
