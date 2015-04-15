#!/system/bin/sh

Count=(1 2 3 4 5)
CMD="/data/app/htc.facetesting/hello-face_O"
Path="/sdcard/fr/Target"

for Num in 1
do 
    echo "# Number ==> $Num"
    Threshold=1
    while [ Threshold -lt 2 ]
    do 
        echo "## Threshold ==> $Threshold"
        for Key in "${Count[@]}"
        do 
           echo "#### Training Face Number  ==> $Key" 

            ## Training Data 
            $CMD -T -p $Path"/Train"$Key -f 0.0667 -F 1.0 -a ANGLE_ULR45 -b ANGLE_ULR15 -c ANGLE_ULR15 -s $Threshold -n $Num -l $Path"/Train_"$Key"_S-"$Threshold"_N-"$Num"_data.dat" -r $Path"/Train_"$Key".txt" > $Path"/Train_Log_"$Key"_S-"$Threshold"_N-"$Num".log"

            ## Testing Data 
            $CMD -t -p $Path"/Testing/" -f 0.0667 -F 1.0 -a ANGLE_ULR45 -b ANGLE_ULR15 -c ANGLE_ULR15 -s $Threshold -n $Num -l $Path"/Train_"$Key"_S-"$Threshold"_N-"$Num"_data.dat"  > $Path"/Testing_Log_"$Key"_S-"$Threshold"_N-"$Num".log"

        done 
        Threshold=$(($Threshold+10))
    done 
done 



