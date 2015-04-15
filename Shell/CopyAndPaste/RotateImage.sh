#!/bin/bash 

ADB_Command_ORG=$1
FilePathName=$2
Value=$3
Current_Range=$4
Rotate=$5
CONVERT=`which convert`
ADB_Command_Shell=$6

$ADB_Command_Shell screencap -p $FilePathName 
$ADB_Command_ORG pull $FilePathName ScreenShot/screenshot-$Value"_"$Current_Range".jpg"
if [ $Rotate == "Rotate" ]
then
    $CONVERT ScreenShot/screenshot-$Value"_"$Current_Range".jpg" -rotate 270  ScreenShot/screenshot-$Value"_"$Current_Range".jpg"
fi

$ADB_Command_Shell rm $FilePathName 
