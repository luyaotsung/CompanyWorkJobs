#!/bin/bash

ADB=`which adb`
CONVERT=`which convert`
Current_SN=1
Current_Range=1
Range=1

### Version Number ###
Major=1
Minor=0
SVN=78


if [ -z "${1+xxx}" ]
then 
    echo "** Use Default Device Serial Number **"
else 
    Device_SN=$1
    echo "** Use Device Serial Number : $Device_SN"
fi 

    
Check_Folder()
{
    if [ ! -d ScreenShot ]
    then
        mkdir ScreenShot  
    fi
}

Delete_JPG()
{
    rm -rf ScreenShot/*
}

Increase_SN()
{
    Current_SN=$(($Current_SN+1))
}

Increase_Range()
{
    #echo "current range => $Current_Range   range =>$Range "
    if [ "$Current_Range" == "$Range" ]
    then
        Current_Range=1
        Increase_SN
    else
       Current_Range=$(($Current_Range+1))
    fi
}

PressBack()
{
    $ADB shell input keyevent 4 &
}

Capture()
{
    local Value=$1
    local Rotate=$2
    
    if [ -z "${Device_SN+xxx}" ]
    then 
        local ADB_Command_Shell="$ADB shell"
        local ADB_Command_ORG=$ADB
    else
        local ADB_Command_Shell="$ADB -s $Device_SN shell"
        local ADB_Command_ORG="$ADB -s $Device_SN "
    fi

    $ADB_Command_Shell "mkdir -p /sdcard/Pictures/Screenshots/"
    FilePathName=/sdcard/Pictures/Screenshots/screenshot-$Value"_"$Current_Range".jpg"
#    $ADB_Command_Shell screencap -p $FilePathName
    ./RotateImage.sh "$ADB_Command_ORG" $FilePathName $Value $Current_Range $Rotate "$ADB_Command_Shell"  > /dev/null 2>&1 & 

#    $ADB_Command pull $FilePathName ScreenShot/screenshot-$Value"_"$Current_Range".jpg"
#    if [ $Rotate == "Rotate" ]
#    then
#        $CONVERT ScreenShot/screenshot-$Value"_"$Current_Range".jpg" -rotate 270  ScreenShot/screenshot-$Value"_"$Current_Range".jpg" 
#    fi
}


Do_Capture()
{
    Execute_Rotate_Script
    Increase_Range_flag=$2
    local SN=`printf "%05d" $1`
    local Check_Rotate=$(adb shell dumpsys display | grep "mCurrentDisplayRect"   | awk '{print $4}') 

    # Rotate
    if [ $Check_Rotate == "1920," ]
    then 
        local Rotate_Value="Rotate"
    # NoRotate
    elif [ $Check_Rotate == "1080," ]
    then
        local Rotate_Value="NoRotate"
    fi 

    Capture $SN $Rotate_Value
    if [ "$Current_Range" == "$Range" ]
    then
        PressBack
    fi

    if [ "$Increase_Range_flag" != "N" ] 
    then
        Increase_Range
    fi
}

Get_Orientation()
{
    Orientation=`$ADB shell dumpsys display | grep "mCurrentOrientation" | cut -d '=' -f 2`
    echo $Orientation
}

Change_Orientation()
{
    ## Landscape  3
    ## Poratit    0
    Rotate=$1
    $ADB shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:$Rotate
}

Locker_Orientation()
{
    #  $Switch  = 0  lock
    #  $Switch  = 1  unlock
    Switch=$1
    $ADB shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:$Switch
}

Create_Rotate_Script()
{
    $ADB push ScreenRotate.sh /system/xbin/ScreenRotate.sh
    $ADB shell chmod 6755 /system/xbin/ScreenRotate.sh
}

Execute_Rotate_Script()
{
    $ADB shell /system/xbin/ScreenRotate.sh
}

## Main 

Check_Folder

Control="Doing"
Create_Rotate_Script
while [ $Control != "Quit" ]
do
    echo "Usage : [Enter] = Start Capture , [r] set range value , [b] breake range count , [m] Modify Range count , [e] = Modify start SN , [d] = Delete All JPG files , [q] = Quit "
    read -p "Current SN [$Current_SN:$Current_Range] : " -s -n 1 Input_Value
    echo ""

    
    if [[ $Input_Value = "" ]]
    then 
        echo " ==> Execute Capture "
        Do_Capture $Current_SN 

    elif [ $Input_Value == "q" ]
    then 
        echo " ==> Execute Quit"
        Control="Quit" 
        sleep 5

    elif [ $Input_Value == "e" ]
    then 
        echo " ==> Execute Modify Start SN"
        read -p " ## Input your new Start Value ==> " New_Start_Value
        Current_SN=$New_Start_Value

    elif [ $Input_Value == "d" ]
    then 
        echo " ==> Execute Delete All Scrrenshot JPG File "    
        Delete_JPG    
        Current_SN=1
        Current_Range=1

    elif [ $Input_Value == "b" ]
    then 
        echo " ==> Execute BREAKE Range capture "

        if [ $Current_Range != 5 ]
        then
            Do_Capture $Current_SN 

        else
            Do_Capture $Current_SN N

        fi
        Current_Range=1
        Increase_SN
        PressBack

    elif [ $Input_Value == "m" ]
    then 
        echo " ==> Execute Modify Range Number "    
        read -p " ## Input your new Start Value ==> " New_Range_Value
        Current_Range=$New_Range_Value

    elif [ $Input_Value == "r" ]
    then 
        echo " ==> Execute SETUP Range Number "    
        read -p " ## Input your Range Value ==> " Range_Value
        Range=$Range_Value

    elif [ $Input_Value == "v" ]
    then 
        echo " Version number => $Major"."$Minor"."$SVN"

    else 
        echo ""
        echo "Usage : [Enter] = Start Capture , [r] set range value , [b] breake range count , [m] Modify Range count , [e] = Modify start SN , [d] = Delete All JPG files , [q] = Quit "
        echo ""
    fi 
done 
