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

#
#array=(HT3CKWM00021 HT42JWM00259 FA42MWM04366)
array=(HT3B5W903278 HT42JWM00259 FA42MWM04366)
#with moto x
#array=(TA64300Y6A HT3B8WM00015 HT3CLWM00090)

    
Check_Folder()
{
    mkdir ScreenShot 
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
    for i in 0 1 2
    do
        $ADB -s ${array[$i]} shell input keyevent 4 &
    done
}

Capture()
{
    local Value=$1
    local Rotate=$2
    
    for i in 0 1 2
    do
        if [ "$i" == 0 ]
        then 
            CAM="GC"
        elif [ "$i" == 1 ]
        then
            CAM="M8"
        else
            CAM="DM"
        fi   
        NewSN=$(printf '%03d' $Value) 
        NewRange=$(printf '%03d' $Current_Range) 
        FilePathName=/sdcard/Pictures/Screenshots/$NewSN"_"$NewRange"-"$CAM".png"
        ADB_Command_Shell="$ADB -s ${array[$i]} shell"
        $ADB_Command_Shell screencap -p  | sed 's/\r$//' > "ScreenShot/"$NewSN"_"$NewRange"-"$CAM".png" &
        echo $ADB_Command_Shell screencap -p $FilePathName
        
    done

}


Do_Capture()
{
    SN=$1
    Capture $SN 
    if [ "$Current_Range" == "$Range" ]
    then
        PressBack
    fi

    if [ "$Increase_Range_flag" != "N" ] 
    then
        Increase_Range
    fi
}



## Main 

Check_Folder

Control="Doing"
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
        sleep 1

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
