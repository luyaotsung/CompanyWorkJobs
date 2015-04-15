#!/usr/bin/bash


ADB=`which adb`

Source=$2
filelistsource=$1

Device_SN=$3
Repeat=0
MaxRepeat=6


removefile()
{
    local file=$1
    echo "remove file from list $file"
    cat $file | while read LINE
    do
        #echo "$ADB -s $Device_SN shell \"rm -f /sdcard/Pictures/visualsearch/$LINE\""
        $ADB -s $Device_SN shell "rm -f /sdcard/Pictures/visualsearch/$LINE"
    done
    echo "finish remove file"
}

cleandata()
{
    $ADB -s $Device_SN shell "pm clear com.htc.visual_search"
}

copyfile()
{
    local input=$1
    local check=0
    echo "copy file from list $file"
    cat $input | while read LINE
    do
        #echo "cp -pv $Source/$LINE /mnt/MTP1/Pictures/VisualSearch/."
        cp -pv $Source/$LINE /mnt/MTP1/Pictures/VisualSearch
        #cp -pv $Source/$LINE /mnt/MTP1/Pictures/VisualSearch
        if [ "$?" -ne "0" ] 
        then
            check=$((check+1))
        fi
    done 
    echo "finish copy file"
    echo "check $check file copy fail"
    return "$check"
}

checkMtp()
{
    echo 123
}

checkCopyFinish()
{
    echo 123
}

launchAutoTool()
{
    $ADB -s $Device_SN shell "am start -n com.htc.visual_search/com.htc.visualsearch.autotest.AutoActivity"
}

startTesting()
{
    
    $ADB -s $Device_SN shell "input touchscreen tap 505 300"
}

startParser()
{
  $ADB -s $Device_SN shell "input touchscreen tap 574 739"
}

checkExtraction()
{
    $ADB shell "dumpsys activity" | grep "com.htc.visual_search/com.htc.visualsearch.autotest.FeatureExtractionActivity"
    local extraction=$?
    echo "extraction $extraction "
    if [ "$extraction" -eq "0" ]
    then 
        return 1
    else
        return 0
    fi
}


checkActivity()
{
    #$ADB shell "dumpsys activity" | grep "com.htc.visual_search/com.htc.visualsearch.autotest.AutoActivity"
    `$ADB shell "dumpsys activity" | grep "com.htc.visual_search/com.htc.visualsearch.autotest.AutoActivity" > /dev/null 2>&1 `
    local activity=$?
    echo >&2 " Check Activity ==> activity $activity " 
    if [ $activity == "0" ]
    then 
        echo "0"
    else
        echo "1"
    fi
}

checkAutoRun()
{
    #$ADB -s $Device_SN shell "dumpsys activity" | grep "com.htc.visual_search/com.htc.visualsearch.autotest.AutoRun"
    `$ADB -s $Device_SN shell "dumpsys activity" | grep "com.htc.visual_search/com.htc.visualsearch.autotest.AutoRun" > /dev/null 2>&1 `
    local autorun=$?
    echo >&2 "Check Auto Run ==> autorun $autorun "
    if [ $autorun == "0" ]
    then 
        echo "0"
    else
        echo "1"
    fi   
}

pullOutput(){
    local sn=$1
    $ADB -s $Device_SN pull /sdcard/test/output/ "output-$sn/"
    $ADB -s $Device_SN pull /sdcard/test/final/ "output-$sn/"
}

removeOutput(){
    $ADB -s $Device_SN shell "rm -rf /sdcard/test/output"
}


stopAutoTest()
{
    $ADB -s $Device_SN shell "am force-stop com.htc.visual_search"
}

AdbReboot()
{
    $ADB -s $Device_SN Reboot
}

doubleCheck()
{
    local ActCheck="0"
    while [ "$ActCheck" == "1" ]
    do 
        echo "check activity"
        local ActCheck=`checkActivity`
        echo "check $ActCheck eq !0"
        sleep 600
    done
    sleep 180
    ActCheck="0"
    while [ "$ActCheck" == "0" ]
    do 
        echo "check AutoRun"
        ActCheck=`checkAutoRun`
       echo "3 min check $ActCheck eq !0"
       sleep 180
    done
   
}

for ListFile in `find $filelistsource -type f`
do
    removefile $ListFile
    cleandata
    copycheck=1
    until [ "$copycheck" -eq "0" ]
    do
        copyfile $ListFile
        copycheck=$?
    done
    sleep 60
    launchAutoTool
    startTesting
    checkextraction=1
    until [ "$checkextraction" -eq "0" ]
    do
        sleep 300
        checkExtraction
        checkextraction=$?
        echo "check extraction $checkextraction eq !0" 
    done
    
    doubleCheck
    sleep 180
    doubleCheck

    #startParser
    pullOutput $Repeat
    removeOutput
    Repeat=$((Repeat+1))
    stopAutoTest

done
