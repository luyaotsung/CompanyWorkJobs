#!/bin/bash 

if [ $# -eq 0 ]
then 
    exit 0
fi 


## Testing_Path : All testing log file will put in this folder
## Training_Path : All training txt file will put in this folder 
## Result_F : Result file with path 
## Report_Path : All report file that create by this script will put in this folder 

Training_File=$1
Result_File=$2
Testing_File=$3
Log_Path=$4

Bash=`which perl`
Threshold=0

Accuracy_F="Accuracy_Report_Perl_"$Training_File".txt"

cat /dev/null > Accuracy_Report_Perl.txt
echo "Key Threshold Candidate Total Expected_Wrong_Detect Wrong_Detect Wrong_Detect_NotExpected Expected_Recognition Not_Expected_Recognition Correct_Recognition Wrong_Recognition_Not_Expected " > $Accuracy_F 

while [ $Threshold -le 1000 ]
do 

    Testing_F=$Testing_File
    Training_F=$Training_File
    Output_F=$Log_Path"/ComparisonResult_"$Training_File"_S"$Threshold".log"
    Result_F=$Result_File
    ## get_Result.pl Training-File Result-File Testing-Log Threshold-Value
    $Bash get_Result.pl $Training_F $Result_F $Testing_F $Threshold > $Output_F 

    Total_Face=`cat $Output_F | grep " Total Face : " | cut -d ":" -f 2`
    Wrong_Detect=`cat $Output_F | grep " Not Face True : " | cut -d ":" -f 2`
    Expected_Recognition=`cat $Output_F | grep " Expected True : " | cut -d ":" -f 2`
    Not_Expected_Recognition=`cat $Output_F | grep " Expected False : " | cut -d ":" -f 2`
    Correct_Recognition=`cat $Output_F | grep "Recognition True : " | cut -d ":" -f 2`
    Wrong_Recognition_Not_Expected=`cat $Output_F | grep " Recognition False (Expected False) : " | cut -d ":" -f 2`
    Wrong_Detect_NotExpected=`cat $Output_F | grep " Not Face False : " | cut -d ":" -f 2`
    Expected_Wrong_Detect=`cat $Output_F | grep " Total Not Face : " | cut -d ":" -f 2`


    echo "$Key $Threshold $Candidate $Total_Face $Expected_Wrong_Detect $Wrong_Detect $Wrong_Detect_NotExpected $Expected_Recognition $Not_Expected_Recognition $Correct_Recognition $Wrong_Recognition_Not_Expected" >> $Accuracy_F
    
    Threshold=$(($Threshold+10))

done 


