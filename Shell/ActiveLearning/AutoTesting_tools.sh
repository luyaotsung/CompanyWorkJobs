#!/bin/bash 


## Push.sh Device_List Job Path 
## Get Value from User 
Device=$1
Job=$2
Path=$3
ADB=`which adb`

## ON : debug is enable , OFF : debug is diable 
Debuging="OFF"

## Device Number and Hardware Serial Number Mapping
Dev_SN[1]="FA2BMW103296" # Device 1
Dev_SN[2]="FA2BMW103450" # Device 2 
Dev_SN[3]="FA2BMW103642" # Device 3 
Dev_SN[4]="FA2BMW103640" # Device 4 
Dev_SN[5]="FA2BMW103364" # Device 5
Dev_SN[6]="123456789012" # Device 6 
Dev_SN[7]="HT337W900056" # Device 7 
Dev_SN[8]="HT338MP00038" # Device 8 
Dev_SN[9]="HT364W900454" # Device 9
Dev_SN[10]="FA3A9WG01238" # Device A
Dev_SN[11]="FA3A9WG01243" # Device B
Dev_SN[12]="123456789012" # Device C

Get_Number()
{
    local Source=$1
    local Target=0

    if [ -z $(echo $Source | sed -e 's/[0-9]//g' ) ]
    then 
        echo $Source
    elif [ -z $(echo $Source | sed -e 's/[a-zA-Z]//g' ) ] 
    then
        Target=$( printf "%d" "'${Source}" )
        Target=$(($Target-55))
        echo $Target
    fi
}

Get_Device_List()
{
    local Source=$1
    local Value=""
    local Target=""

    for (( i=0; i<${#Source}; i=i+1 ))
    do 
        Value=$(Get_Number ${Source:$i:1})
        Target="$Target $Value"
    done

    echo $Target

}

## Get Device List 
Device_List=$(Get_Device_List $Device)
echo $Device_List

###########################################
###########################################
## Minor Feature 

Usage()
{
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++ Usage       : Push.sh [Device List] [Job Item] [Source Path]                                    ++"
    echo "++ Device List : Any Device ID , 1, 13, 14, A, AB, ABC, 89 or 123456789                            ++"
    echo "++ Job Item    : Update_All | Update_Setting | Execute | GetData | Reboot | Force_Stop             ++" 
    echo "++ Source Path : [Source Path]/Dev00?                                                              ++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    exit 0
}

Reboot()
{
    local Device_SN=$1

    echo "---Reboot---"
    $ADB -s $Device_SN reboot 
}

Uninstall()
{
    local Device_SN=$1    

    echo "---Uninstall---"
    $ADB -s $Device_SN uninstall com.htc.visual_search  
    $ADB -s $Device_SN uninstall com.example.stoptest 
}

Push_Setting()
{
    local Device_SN=$1
    local Device_Path=$2

    echo "---Push Setting---"
    $ADB -s $Device_SN shell "rm -rf /sdcard/test"
    $ADB -s $Device_SN shell "mkdir /sdcard/test"
    $ADB -s $Device_SN push $Device_Path /sdcard/test/ 
}

Pull_Setting()
{
    local Device_SN=$1
    local Device_Path=$2

    echo "---Pull Setting---"
    if [ ! -d "$Device_Path" ]
    then
        mkdir -p $Device_Path
    fi
    $ADB -s $Device_SN pull /sdcard/test $Device_Path
}


Install()
{
    local Device_SN=$1
    local Install_Device_Path=$2

    echo "---Install---"
    $ADB -s $Device_SN install $Install_Device_Path"/InvokePickerActivity.apk"
    $ADB -s $Device_SN install $Install_Device_Path"/StopTest.apk"
    #$ADB -s $Device_SN install $Install_Device_Path"/MediaManager.apk"
}

Launch()
{
    local Device_SN=$1

    echo "---Launch---"
    $ADB -s $Device_SN shell "am start -n com.htc.visual_search/com.htc.visualsearch.autotest.AutoActivity"
}

Execute()
{
    local Device_SN=$1
    local Device=$2

    echo "---Execute---"
    if [ $Device == "1" ] || [ $Device == "2" ] || [ $Device == "3" ] || [ $Device == "4" ] || [ $Device == "5" ] 
    then 
        echo "------HTC One X Plus------"
        $ADB -s $Device_SN shell "input touchscreen tap 370 210"    
    elif [ $Device == "6" ] || [ $Device == "7" ] || [ $Device == "8" ]  || [ $Device == "9" ] 
    then 
        echo "------HTC New One------"
        $ADB -s $Device_SN shell "input touchscreen tap 505 300"    
        # Parser log 
        #$ADB -s $Device_SN shell "input touchscreen tap 545 739"    
    fi 
}

Stop()
{
    local Device_SN=$1

    echo "---Stop---"
    $ADB -s $Device_SN shell "am start -n com.example.stoptest/com.example.stoptest.MainActivity"
    $ADB -s $Device_SN shell "am force-stop com.example.stoptest"
}


##################################
##################################
## Major Feature 
Update_All()
{
    local Device_SN=$1
    local Device_Path=$2
    local Install_Device_Path=$3
    local Device_Name=$4

    Uninstall $Device_SN
    Push_Setting $Device_SN $Device_Path
    Install $Device_SN $Install_Device_Path
    Launch $Device_SN
    Execute $Device_SN $Device_Name
}

Update_Setting()
{
    local Device_SN=$1
    local Device_Path=$2
    local Install_Device_Path=$3
    local Device_Name=$4

    Push_Setting $Device_SN $Device_Path
    Launch $Device_SN
}

Execute_Extract()
{
    local Device_SN=$1
    local Device_Path=$2
    local Install_Device_Path=$3
    local Device_Name=$4

    Launch $Device_SN
    Execute $Device_SN $Device_Name
}

Force_Stop()
{
    local Device_SN=$1
    local Device_Path=$2
    local Install_Device_Path=$3
    local Device_Name=$4

    Stop $Device_SN
}

if [ $Job == "Update_All" ]
then 
    echo "Job : $Job " 

    for Device_ID in $Device_List
    do 
        Org_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`"/test/"
        Org_Install_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`
        
        echo "Number : $Device_ID Dev SN : ${Dev_SN[$Device_ID]}"

        if [ $Debuging == "ON" ]
        then 
            echo "Update_All ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID"
        elif [ $Debuging == "OFF" ] 
        then
            Update_All ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID
        fi
    done 
elif [ $Job = "Update_Setting" ]
then 
    echo "Job : $Job"

    for Device_ID in $Device_List
    do 
        Org_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`"/test/"
        Org_Install_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`
        
        echo "Number : $Device_ID Dev SN : ${Dev_SN[$Device_ID]}"
        
        if [ $Debuging == "ON" ]
        then
            echo "Update_Setting ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID"
        elif [ $Debuging == "OFF" ] 
        then
            Update_Setting ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID
        fi        
    done 

elif [ $Job = "Execute" ]
then 
    echo "Job : $Job"

    for Device_ID in $Device_List
    do 
        Org_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`"/test/"
        Org_Install_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`
        
        echo "Number : $Device_ID Dev SN : ${Dev_SN[$Device_ID]}"

        if [ $Debuging == "ON" ]
        then
            echo "Execute_Extract ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID"
        elif [ $Debuging == "OFF" ] 
        then
            Execute_Extract ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID
        fi        
    done 

elif [ $Job = "GetData" ]
then
    PullFolderName=`date +%Y%m%d%H%M`
 
    echo "Job : $Job "
    for Device_ID in $Device_List
    do 
        Org_Device_Path=$Path"/Pull/$PullFolderName/Dev"`printf "%03d\n" $Device_ID`"/"
        
        echo "Number : $Device_ID Dev SN : ${Dev_SN[$Device_ID]}"

        if [ $Debuging == "ON" ]
        then
            echo "GetData ${Dev_SN[$Device_ID]} $Org_Device_Path $Device_ID"
        elif [ $Debuging == "OFF" ] 
        then
            Pull_Setting ${Dev_SN[$Device_ID]} $Org_Device_Path $Device_ID
        fi        
    done 

elif [ $Job = "Force_Stop" ]
then 
    echo "Job : $Job"

    for Device_ID in $Device_List
    do 
        Org_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`"/test/"
        Org_Install_Device_Path=$Path"/Dev"`printf "%03d\n" $Device_ID`
        
        echo "Number : $Device_ID Dev SN : ${Dev_SN[$Device_ID]}"

        if [ $Debuging == "ON" ]
        then
            echo "Force_Stop ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID"
        elif [ $Debuging == "OFF" ] 
        then
            Force_Stop ${Dev_SN[$Device_ID]} $Org_Device_Path $Org_Install_Device_Path $Device_ID
        fi        
    done

elif [ $Job = "Reboot" ]
then 
    echo "Job : $Job"

    for Device_ID in $Device_List 
    do 

        echo "Number : $Device_ID Dev SN : ${Dev_SN[$Device_ID]}"

        if [ $Debuging == "ON" ]
        then
            echo "Reboot ${$Dev_SN[$Device_ID]}"
        elif [ $Debuging == "OFF" ] 
        then
            Reboot ${Dev_SN[$Device_ID]}
        fi        
    done 

else 
    Usage
fi 
