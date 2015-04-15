#!/bin/bash 


## $1 working path 
Target_Path=$1
Format_Size=$2
CMD_convert=`which convert`
CMD_identify=`which identify`
CMD_cut=`which cut`
CMD_rm=`which rm`
#Log_path="/home/Script/Report/"
#Now_date=`date +"%Y-%m-%d_%H-%M"`
#File_resize=$Log_path"Special_Resize_"$Now_date


do_find()
{
    local path=$1
    local level=$2
    local resolution=""
    local height=""
    local width=""
    local tab_string=""

    local Folder_List=`ls -l $path | egrep '^d' | awk '{print $9}'`
    local File_List=`ls -l $path | egrep '^-' | awk '{print $9}'`


    for ((i=0;i<=$level;i++))
    do
        tab_string=$tab_string"."
    done

    level=$(($level+1))
    for sub_dir in $Folder_List
    do
        do_find "$path/$sub_dir" $level
    done

    echo -e $tab_string"d $path"
    for sub_file in $File_List
    do 

        real_file=$path"/"$sub_file

        Ext_name=`echo $sub_file | awk -F . '{print $NF}' `
        if [ $Ext_name = "JPG" ] || [ $Ext_name = "jpg" ]
        then 
            resolution=`$CMD_identify $real_file | awk '{print $3}'`
        
            $CMD_convert $real_file "-resize" $Format_Size $real_file

            resolution_new=`$CMD_identify $real_file | awk '{print $3}'`
           # echo "$real_file $resolution $resolution_new " >> $File_resize 2>&1
            echo -e $tab_string" - $sub_file  $resolution  $resolution_new"
        fi
        
    done 
}

echo "Start Path = $Target_Path"

# echo "" > $File_resize 2>&1 

do_find $Target_Path 0 
