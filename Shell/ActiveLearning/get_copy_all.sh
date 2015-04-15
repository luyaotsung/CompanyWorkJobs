#!/bin/bash 

F_array=( FAM1 FAM2 FAM3 )

if [ ! -d All ]
then 
    echo "Create All"
    mkdir All
    mkdir -p All/Train
    mkdir -p All/Test
    mkdir -p All/Train/01
    mkdir -p All/Train/02
    mkdir -p All/Train/03
    mkdir -p All/Train/04
    mkdir -p All/Train/05
    mkdir -p All/Train/06
    mkdir -p All/Train/07
    mkdir -p All/Train/08
    mkdir -p All/Train/09
    mkdir -p All/Train/10
else 
    echo "Delete All & Careate new one "
    rm -rf All
    mkdir All
    mkdir -p All/Train
    mkdir -p All/Test
    mkdir -p All/Train/01
    mkdir -p All/Train/02
    mkdir -p All/Train/03
    mkdir -p All/Train/04
    mkdir -p All/Train/05
    mkdir -p All/Train/06
    mkdir -p All/Train/07
    mkdir -p All/Train/08
    mkdir -p All/Train/09
    mkdir -p All/Train/10
fi 

touch All/All_Result.txt
touch All/All_Training_01.txt
touch All/All_Training_02.txt
touch All/All_Training_03.txt
touch All/All_Training_04.txt
touch All/All_Training_05.txt
touch All/All_Training_06.txt
touch All/All_Training_07.txt
touch All/All_Training_08.txt
touch All/All_Training_09.txt
touch All/All_Training_10.txt

for f_name in "${F_array[@]}"
do 
    
    Key=`printf "%02d\n" $index`  
    
    ## Copy Test File to target Folder 
    cp -Rvpf $f_name/Test/* All/Test   > /dev/null 2>&1 

    ## Merge Result File 
    cat $f_name"/"$f_name"_Result.txt" >> "All/All_Result.txt" 
    
done 

for ((i=1;i<=10;i++))
do
    Key=`printf "%02d\n" $i`
    index=1
    for f_name_1 in "${F_array[@]}"
    do 
        ## Merge echo train face file 
        cat $f_name_1"/"$f_name_1"_Training_"$Key".txt" >> "All/All_Training_"$Key".txt"
        
        ## copy train face file to 
        echo "cp -Rvpf $f_name_1/Train/$Key/* All/Train/$Key "
        cp -Rvpf $f_name_1/Train/$Key/* All/Train/$Key > /dev/null 2>&1 
    done 
done 
