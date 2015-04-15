#!/bin/bash 

Path=$1
ExifTool=`which exiftool`
#ExifTool="/home/root/Template/Image-ExifTool-9.45/exiftool"
Mogrify=`which mogrify`
File="/tmp/22"
File_List=`find $Path -name "*.jpg" > $File`

while read line 
do 
    #$ExifTool -ExifIFD:DateTimeOriginal=now  $line 
    $Mogrify -strip $line
    $ExifTool -ExifIFD:DateTimeOriginal="1900:12:12 11:11:11"  $line 
done < "$File"


$ExifTool "\"-DataTimeOriginal-=0:0:0 2:0:0\"" $1

