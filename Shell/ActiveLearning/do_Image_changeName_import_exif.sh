#!/bin/bash 

## 

## $1 Working path 
## $2 Final Path 


Target_Path=$1
CMD_cut=`which cut`
CMD_rm=`which rm`
EXIFTools=`which exiftool`
Total_jpg=`find $Target_Path -name "*.jpg" | wc -w`
Total_JPG=`find $Target_Path -name "*.JPG" | wc -w`
Total_Count=$(($Total_jpg+$Total_JPG))
Real_Count=1



do_change()
{
    local path=$1
    local level=$2
    local Name=$3
    local Name_count=""
    local tab_string=""

    local Folder_List=`ls -l $path | egrep '^d' | awk '{print $9}'`
    local File_List=`ls -l $path | egrep '^-' | awk '{print $9}'`
    local File_count=`ls -l $path | egrep '^-' | awk '{print $9}' | wc -w`


    abc=`echo $File_List | grep "Thumbs.db"` 
    if ((!$?)) 
    then 
        File_count=$(($File_count-1))
    fi 

    for ((i=0;i<=$level;i++))
    do
        tab_string=$tab_string"."
    done

    level=$(($level+1))
    for sub_dir in $Folder_List
    do
        Inject_name=$Name"_"$sub_dir
        do_change "$path/$sub_dir" $level $Inject_name
    done

    echo -e $tab_string "d $path"
  
    cd $path 
    for sub_file in $File_List
    do 

        Name_Count=$Real_Count"-"$Total_Count

        Ext_name=`echo $sub_file | awk -F . '{print $NF}' `
        if [ $Ext_name = "JPG" ] || [ $Ext_name = "jpg" ]
        then
            Name_count=$(($Name_count+1))
            Name_String=`printf "%03d\n" $Name_count`
            Inject_EXIF $sub_file 
            mv $sub_file $Name"_"$File_count"_"$Name_String"_"$Name_Count".jpg"
            echo $sub_file $Name"_"$File_count"_"$Name_String"_"$Name_Count".jpg"

            Real_Count=$((Real_Count+1))
        fi 
    done 

}

function Inject_EXIF(){
    local input_file=$1

    Create_EXIF_CSV $inpurt_file "2013-11-29 19:46:46" 
	$EXIFTools -exif:all= -csv=/tmp/exif_tmp.csv $input_file
    rm -f $input_file"_original"

}

function Create_EXIF_CSV(){
    file_name=$1
    OrignalDate=$2
    GPSLa=$3
    GPSLo=$4

## OrignalData  =  2013:11:13 13:07:18,
## GPSLa,GPSLo "24 deg 58' 45.22"" N","121 deg 32' 44.71"" E",
    msg1="SourceFile,DateTimeOriginal,CreateDate,GPSLatitudeRef,GPSLongitudeRef,GPSAltitudeRef,GPSProcessingMethod,GPSAltitude,GPSLatitude,GPSLongitude,GPSPosition"
    msg2="$file_name,$OrignalDate,$OrignalDate,North,East,Above Sea Level,ASCII,0 m Above Sea Level,\"24 deg 58' 45.22\"\" N\",\"121 deg 32' 44.71\"\" E\",\"24 deg 58' 45.22\"\" N, 121 deg 32' 44.71\"\" E"
	echo $msg1 > /tmp/exif_tmp.csv
	echo $msg2 >> /tmp/exif_tmp.csv

}

echo "Start Path = $Target_Path,  Total Count = $Total_Count "

#do_change $Target_Path 0 " "
