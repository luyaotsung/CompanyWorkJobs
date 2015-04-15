#!/bin/bash


EXIFTools=`which exiftool`
Path=$1
Target_Path=$2

count=1

TMP_Name="/tmp/sort.list"
Sort_File="sort.done.list"

`find $Path -name "*.jpg" > $TMP_Name  && cat $TMP_Name | sort > $Sort_File`



function Inject_EXIF(){
    local input_file=$1
    local COUNT=$2
    
    echo "input_file ==> $input_file "
    echo "COUNT ==>  $COUNT "
    
    TodayDateTime=$(date +%Y-%m-%d\s%T )
   
    CalDateTime=$(date +%s -d "$TodayDateTime")
    PlusTwoMin=$((60*60*$COUNT))

    echo "minus   ==> $PlusTwoMin "

    FinalDateTime=$(($CalDateTime-$PlusTwoMin))


    FinalDateTime=$(date +%Y-%m-%d\ %H:%M:%S -d "1970-01-01 UTC $FinalDateTime seconds")
    
    echo "DATE TIME ==>$FinalDateTime<==="
    Create_EXIF_CSV "$input_file" "$FinalDateTime"
    $EXIFTools -F -m -csv=tmp/exif_tmp.csv $input_file
    rm -f $input_file"_original"
    rm -f "/tmp/exif_tmp.csv"

}

function Create_EXIF_CSV(){
    file_name=$1
    OrignalDate=$2
    CalDateTime=$(date +%s -d "$OrignalDate")
    FinalDateStamp=$(date +%Y:%m:%d -d "1970-01-01 UTC $CalDateTime seconds")
    FinalTimeStamp=$(date +%H:%M:%S -d "1970-01-01 UTC $CalDateTime seconds")

    #msg1="SourceFile,DateTimeOriginal,CreateDate,ModifyDate,GPSDateTime,GPSDateStamp,GPSTimeStamp"
    msg1="SourceFile,DateTimeOrignal,SubSecDateTimeOriginal,CreateDate,ModifyDate,GPSDateStamp,GPSTimeStamp"
    msg2="$file_name,$OrignalDate,$OrignalDate,$OrignalDate,$OrignalDate,$FinalDateStamp,$FinalTimeStamp"
	echo $msg1 > tmp/exif_tmp.csv
	echo $msg2 >> tmp/exif_tmp.csv
}

mkdir -p tmp/$Path
mkdir -p $Target_Path



while read line 
do 

    echo "$count $line $Target_Path"
    #`do_changeEXIF_Date.sh $line $count`
    cp $line tmp/$Path
    Inject_EXIF tmp/$line  $count
    #Erase_Path=$Target_Path"/*"
    #adb -s $Device shell "rm -rf $Erase_Path"
    #sleep 0.5
    
    #adb -s $Device push $line $Target_Path
    cp tmp/$line $Target_Path
    #rm -f tmp/$line

    count=$((count+1))

done < "$Sort_File"




