#!/bin/bash 

## $1 Expected_Result 
## $2 Testing Log File 

Expected_Result=$1
Testing_Result=$2
Trained_F=$3

Path=`pwd`

## Set Gobal Value 
Total_Face_Count=0
Wrong_Detect_Count=0
Wrong_Detect_NotExpected_Count=0
Expected_Recognition_Count=0
Not_Expected_Recognition_Count=0
Correct_Recognition_Count=0
Wrong_Recognition_Total_Count=0
Wrong_Recognition_NotExpected_Count=0

Test_Count=0

get_trained_faces()
{
    Trained_Face=`cat $1 | grep FAM | cut -d " " -f 5  | cut -f 5 |  sort | uniq`
    echo $Trained_Face
    echo ""
}
    

in_training_data()
{
    ## $1 = Face Name 
    local c_name=$1
    local result=1

    for l_name in $Trained_Face
    do
        if [ "$l_name" == "$c_name" ]
        then 
            result=0
        fi
    done 
    return $result
}

compare_gap()
{
    ## $1 = First Value 
    ## $2 = Second Value 
    local First=$1
    local Second=$2
    local Check=0

    if [ $First -ge $Second ]
    then 
        Check=$(($First-$Second))
    else 
        Check=$(($Second-$First))
    fi
    if [ $Check -lt 11 ]
    then 
        return 0
    else 
        return 1 
    fi 
}

Compare_Position()
{
    ## $1 = Testing File 
    ## $2 = Testing File Line Number
    ## $3 = Result File Line Number
 
    local Testing_F=$1
    local Testing_L=$2
    local Result_L=$3

    #echo "Compar_Position Testing File : $Testing_F , Testing Line : $Testing_L, Result Line : $Result_L"

    local Testing_x1=`sed $Testing_L'q;d' $Testing_F | cut -f 2 | cut -d "," -f 1`
    local Testing_y1=`sed $Testing_L'q;d' $Testing_F | cut -f 2 | cut -d "," -f 2`
    local Testing_x2=`sed $Testing_L'q;d' $Testing_F | cut -f 3 | cut -d "," -f 1`
    local Testing_y2=`sed $Testing_L'q;d' $Testing_F | cut -f 3 | cut -d "," -f 2`
    local Testing_x3=`sed $Testing_L'q;d' $Testing_F | cut -f 4 | cut -d "," -f 1`
    local Testing_y3=`sed $Testing_L'q;d' $Testing_F | cut -f 4 | cut -d "," -f 2`
    local Testing_x4=`sed $Testing_L'q;d' $Testing_F | cut -f 5 | cut -d "," -f 1`
    local Testing_y4=`sed $Testing_L'q;d' $Testing_F | cut -f 5 | cut -d "," -f 2`
    
    local Result_x1=`sed $Result_L'q;d' $Expected_Result | cut -f 1 | cut -d "," -f 1`
    local Result_y1=`sed $Result_L'q;d' $Expected_Result | cut -f 1 | cut -d "," -f 2`
    local Result_x2=`sed $Result_L'q;d' $Expected_Result | cut -f 2 | cut -d "," -f 1`
    local Result_y2=`sed $Result_L'q;d' $Expected_Result | cut -f 2 | cut -d "," -f 2`
    local Result_x3=`sed $Result_L'q;d' $Expected_Result | cut -f 3 | cut -d "," -f 1`
    local Result_y3=`sed $Result_L'q;d' $Expected_Result | cut -f 3 | cut -d "," -f 2`
    local Result_x4=`sed $Result_L'q;d' $Expected_Result | cut -f 4 | cut -d "," -f 1`
    local Result_y4=`sed $Result_L'q;d' $Expected_Result | cut -f 4 | cut -d "," -f 2`


    #echo "R => $Result_x1,$Result_y1 $Result_x2,$Result_y2 $Result_x3,$Result_y3 $Result_x4,$Result_y4"
    #echo "T => $Testing_x1,$Testing_y1 $Testing_x2,$Testing_y2 $Testing_x3,$Testing_y3 $Testing_x4,$Testing_y4"

    if ( compare_gap $Testing_x1 $Result_x1 ) && ( compare_gap $Testing_x2 $Result_x2 ) && ( compare_gap $Testing_x3 $Result_x3 ) && ( compare_gap $Testing_x4 $Result_x4 ) && ( compare_gap $Testing_y1 $Result_y1 ) && ( compare_gap $Testing_y2 $Result_y2 ) && ( compare_gap $Testing_y3 $Result_y3 ) && ( compare_gap $Testing_y4 $Result_y4 ) 
    then 
        #echo "R $Result_x1,$Result_y1 $Result_x2,$Result_y2 $Result_x3,$Result_y3 $Result_x4,$Result_y4 "
        #echo "T $Testing_x1,$Testing_y1 $Testing_x2,$Testing_y2 $Testing_x3,$Testing_y3 $Testing_x4,$Testing_y4 "
        Shit=" $Testing_x1,$Testing_y1 $Testing_x2,$Testing_y2 $Testing_x3,$Testing_y3 $Testing_x4,$Testing_y4 "
        return 0
    else 
        return 1
    fi 
}


Get_Line_Number()
{
    local Source=$1
    local String=$2
    local Value=0

    Value=`cat $Source | grep -n $String | cut -d ":" -f 1`
    echo $Value

}

## Testing_Result is testing log file
## Expected_Result is expected result txt file

Expected_Result=$1
Testing_Result=$2
Trained_F=$3
./clear.sh $Expected_Result
./clear.sh $Testing_Result
./clear.sh $Trained_F

get_trained_faces $Trained_F

Testing_File_List=`cat $Testing_Result | grep "jpg" | cut -f 2 | sort ` 


for testing_file_name in $Testing_File_List 
do 
    T_Line_Number=$( Get_Line_Number $Testing_Result $testing_file_name ) 
    R_Line_Number=$( Get_Line_Number $Expected_Result $testing_file_name ) 

    T_Count_Line_Number=$(($T_Line_Number+2))
    R_Count_Line_Number=$(($R_Line_Number+1))

    T_Count=`sed $T_Count_Line_Number'q;d' $Testing_Result | cut -f 2 `
    R_Count=`sed $R_Count_Line_Number'q;d' $Expected_Result `

    if [ $T_Count != 0 ] && [ $R_Count != 0 ]
    then 

        for ((R_C=1;R_C<=$R_Count;R_C++))
        do
            Correct_R_Line_Number=$(($R_C+$R_Count_Line_Number))

            for ((T_C=1;T_C<=$T_Count;T_C++))
            do
                Correct_T_Line_Number=$((((2*$T_C)-1)+$T_Count_Line_Number))

                if [ ! -z  $T_Line_Number ] && [ ! -z $R_Line_Number ]
                then 
                    ## echo "Correct_T_Line_Number: $Correct_T_Line_Number , Correct_R_Line_Number: $Correct_R_Line_Number"
                    if Compare_Position $Testing_Result $Correct_T_Line_Number $Correct_R_Line_Number
                    then 

                        Total_Face_Count=$(($Total_Face_Count+1))
#                       echo "Correct_T_Line_Number: $Correct_T_Line_Number , Correct_R_Line_Number: $Correct_R_Line_Number , Total Count: $Total_Face_Count"
                        T_Name=`sed $Correct_T_Line_Number'q;d' $Testing_Result | cut -f 7 `
                        R_Name=`sed $Correct_R_Line_Number'q;d' $Expected_Result | cut -f 5 `

                        if ( in_training_data $R_Name )
                        then 
                            Expected_Recognition_Count=$(($Expected_Recognition_Count+1))
                            #echo "Expected => $R_Name $Shit"
                        fi

                        if ( ! in_training_data $R_Name )
                        then
                            if [ "$R_Name" != ""  ]
                            then 
                                Not_Expected_Recognition_Count=$(($Not_Expected_Recognition_Count+1)) 
                                #echo "Not_Expected => $R_Name $Shit"
                            fi
                        fi 

                     
                        if [ "$T_Name" == "$R_Name" ]
                        then 
                            if [ "$T_Name" == "" ]
                            then
                                Wrong_Detect_Count=$(($Wrong_Detect_Count+1)) 
                                ##echo "XX_Wrong_Detect_Count  R=$R_Name T=$T_Name"
                            else 
                                Correct_Recognition_Count=$(($Correct_Recognition_Count+1))
                            fi 
                        fi 

                        if [ "$R_Name" != "" ] && [  "$T_Name" != "" ] && [ "$T_Name" != "$R_Name" ]
                        then 
                            ## Is a face and recognition a face but recognition a wrong face 
                            if ( ! in_training_data $R_Name ) 
                            then 
                                Wrong_Recognition_NotExpected_Count=$(($Wrong_Recognition_NotExpected_Count+1)) 
                            fi 
                            Wrong_Recognition_Total_Count=$(($Wrong_Recognition_Total_Count+1))
                        fi 


                        if [ "$R_Name" == "" ] && [  "$T_Name" != "" ] 
                        then 
                            #echo  "R= T=X"
                            Wrong_Recognition_Total_Count=$(($Wrong_Recognition_Total_Count+1))
                            Wrong_Detect_NotExpected_Count=$(($Wrong_Detect_NotExpected_Count+1))
                            ## echo "ZZ_Wrong_Detect_Count  R=$R_Name T=$T_Name"
                        fi
 
                        if [ "$R_Name" != "" ] && [ "$T_Name" == "" ] 
                        then 
                            #echo  "R=X T= "
                            if  ( in_training_data $R_Name )
                            then 
                                Wrong_Recognition_Total_Count=$(($Wrong_Recognition_Total_Count+1))
                            fi 
                        fi  

   			            echo "Result Name = $R_Name, Training Name = $T_Name "
			            echo "TC=$Total_Face_Count WD:$Wrong_Detect_Count ERC:$Expected_Recognition_Count NERC:$Not_Expected_Recognition_Count CRC:$Correct_Recognition_Count WRTC:$Wrong_Recognition_Total_Count WRNEC:$Wrong_Recognition_NotExpected_Count "
			            echo "$Shit : $R_Name : $T_Name : TC :  $Expected_Recognition_Count NERC : $Not_Expected_Recognition_Count CRC : $Correct_Recognition_Count WRTC : $Wrong_Recognition_Total_Count WRNEC: $Wrong_Recognition_NotExpected_Count "

                        echo ""
                    fi
                fi
                
            done 
        done 
    fi 

done 

echo "001 Total Face Count = $Total_Face_Count "
echo "002 Match Face Count = $(($Total_Face_Count-$Wrong_Detect_Count)) "
echo "003 Wrong Detect Count = $Wrong_Detect_Count"
echo "004 Expected Recognition Count = $Expected_Recognition_Count"
echo "005 Not Expected Recognition Count = $Not_Expected_Recognition_Count"
echo "006 Correct Recognition Count = $Correct_Recognition_Count"
echo "007 Wrong Recognition Total Count = $Wrong_Recognition_Total_Count"
echo "008 Wrong Recognition Not Expected Count = $Wrong_Recognition_NotExpected_Count"
echo "009 Wrong Detect Not Expected Count = $Wrong_Detect_NotExpected_Count"
