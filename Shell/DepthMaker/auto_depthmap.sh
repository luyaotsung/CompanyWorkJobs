#!/usr/bin/bash


Count=1


for m_imageDir in `adb shell ls /storage/sdcard0/DepthMaker  `
do
    Dir=`echo $m_imageDir | tr -d '\r\n'`
    echo "==>"$m_imageDir"<=="
    CMD_1="/data/DepthMakerBin/CalibrateMultiView /sdcard/DepthMaker/$Dir /sdcard/DepthMaker/$Dir -ff 920 > /dev/null"
    CMD_2="/data/DepthMakerBin/YuPingDepthEstimationCall /sdcard/DepthMaker/$Dir > /dev/null"

    echo "CMD 001 ==> $CMD_1"
    echo "CMD 002 ==> $CMD_2"

        adb shell $CMD_1
        adb shell $CMD_2 

    Count=$((Count+1))

done

#
#for((i=1;i<=9;i++));
#do
#    for file in 02$i/*.jpg
#    do
#        filename=$(basename $file .jpg)
#        cp $file ../../target/
#        find 02$i"_D"/ -name $filename"*_dm1.jpg" -exec cp {} ../../target/ \; 
#
#        #echo $filename
#    done
#    
#done
#
#

