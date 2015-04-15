#!/bin/bash 

if [ $# -eq 0 ]
then 
    exit 0
fi 

## $1 = Result file 

## Testing_Path : All testing log file will put in this folder
## Training_Path : All training txt file will put in this folder 
## Result_F : Result file with path 
## Report_Path : All report file that create by this script will put in this folder 

Testing_Path="Testing"
Training_Path="Training"
Result_Path=$1
Report_Path="Report"

Bash=`which bash`

Testing_list=`find $Testing_Path -name *.log `


cat /dev/null > Accuracy_Report_Bash.txt
echo "Key Threshold Candidate Total Expected_Wrong_Detect Wrong_Detect Wrong_Detect_NotExpected Expected_Recognition Not_Expected_Recognition Correct_Recognition Wrong_Recognition_Not_Expected " > Accuracy_Report_Bash.txt 

for file in $Testing_list 
do 
    Threshold=`echo $file | cut -d "_" -f 4| cut -d "-" -f 2`
    Candidate=`echo $file | cut -d "_" -f 5| cut -d "." -f 1 | cut -d "-" -f 2`
    Key=`echo $file | cut -d "_" -f 3`

    echo "Key ==> $Key : Threshold ==> $Threshold : Candidate ==> $Candidate "

    
    Testing_F=$file
    Training_F=$Training_Path"/All_Training_"$Key".txt"
    Output_F=$Report_Path"/Bash_K-"$Key"_S-"`printf "%04d\n" $Threshold`"_N-"`printf "%02d\n" $Candidate`
    Result_F=$Result_Path

    $Bash get_Result.sh $Result_F $Testing_F $Training_F > $Output_F 


    #./evaluation.py --training $Training_F  --result $Result_F --log $Testing_F --html_template template.html --output_html $Output_F".html" --image_path img --overwrite 1  > $Output_F"_Python" 2>&1 

    Total_Face=`cat $Output_F | grep "001 Total Face Count" | cut -d "=" -f 2`
    Wrong_Detect=`cat $Output_F | grep "003 Wrong Detect Count" | cut -d "=" -f 2`
    Expected_Recognition=`cat $Output_F | grep "004 Expected Recognition" | cut -d "=" -f 2`
    Not_Expected_Recognition=`cat $Output_F | grep "005 Not Expected Recognition" | cut -d "=" -f 2`
    Correct_Recognition=`cat $Output_F | grep "006 Correct Recognition" | cut -d "=" -f 2`
    Wrong_Recognition_Not_Expected=`cat $Output_F | grep "008 Wrong Recognition Not Expected" | cut -d "=" -f 2`
    Wrong_Detect_NotExpected=`cat $Output_F | grep "009 Wrong Detect Not Expected Count" | cut -d "=" -f 2`
    Expected_Wrong_Detect=$(($Wrong_Detect + $Wrong_Detect_NotExpected))


    echo "$Key $Threshold $Candidate $Total_Face $Expected_Wrong_Detect $Wrong_Detect $Wrong_Detect_NotExpected $Expected_Recognition $Not_Expected_Recognition $Correct_Recognition $Wrong_Recognition_Not_Expected" >> Accuracy_Report_Bash.txt

done 


