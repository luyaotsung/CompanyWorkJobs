#!/bin/bash 

## 

## $1 Working path 
## $2 gps data Path 
## $3 gps import switch


Target_Path=$1
GPSImportSwitch=$2
CMD_cut=`which cut`
CMD_rm=`which rm`
EXIFTools=`which exiftool`
Total_jpg=`find $Target_Path -name "*.jpg" | wc -w`
Total_JPG=`find $Target_Path -name "*.JPG" | wc -w`
Total_Count=$(($Total_jpg+$Total_JPG))
Real_Count=1

totalcount=0

do_change()
{
    local path=$1
    local level=$2
    local Name=$3
    local Name_count=""
    local tab_string=""

    local Folder_List=`ls -l $path | egrep '^d' | awk '{print $9}'`
    local File_List=`ls -l $path | egrep '^-' | awk '{print $9}'`
    local File_count=`ls -l $path | egrep '^-' | awk '{print $9}' | wc -w`
    #local File_count=`find $path -name "*.jpg" | wc -l `


    abc=`echo $File_List | grep "Thumbs.db"` 
    if ((!$?)) 
    then 
        File_count=$(($File_count-1))
    fi 

    for ((i=0;i<=$level;i++))
    do
        tab_string=$tab_string"."
    done

    level=$(($level+1))
    for sub_dir in $Folder_List
    do
        Inject_name=$Name"_"$sub_dir
        #echo "Inject name  $Inject_name "
        #if echo $Inject_name  |grep  -q ""
        #then

        #fi
        do_change "$path/$sub_dir" $level $Inject_name
    done

    echo -e $tab_string "d $path"
  
    cd $path 
    for sub_file in $File_List
    do
        #echo "Name $Name"
        Ext_name=`echo $sub_file | awk -F . '{print $NF}' `
        if [ $Ext_name = "JPG" ] || [ $Ext_name = "jpg" ]
        then
            #echo " $totalcount $Real_Count  $Total_Count"
            gpsdateG=""
            Name_count=$(($Name_count+1))
            Name_String=`printf "%03d\n" $Name_count`
            if echo $Name | grep -q "_Scenario"
            then 
                beforefinalname=$Name"_"$Name_count".jpg"
            else
                beforefinalname=$Name"_L-_D-_"$Name_count".jpg"
            fi 
            #gpsdate=$(echo $beforefinalname | grep -q '/.*?(L-.*?_F).*/' )
            gpsdateG=`/bin/perl /media/sf_Photo_Materials/GetFolderGPS.pl $beforefinalname`
            gpsdateD=`/bin/perl /media/sf_Photo_Materials/GetFolderDate.pl $beforefinalname`
            #echo "gpsdateG $gpsdateG"
            #echo "gpsdateD $gpsdateD"
            if echo $Name | grep -q "Scenario"
            then
                echo $Name
                gpsstring=$(Inject_EXIF $sub_file $gpsdateG $gpsdateD $totalcount  $Name_count )
                echo $gpsstring
                beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                if echo $beforefinalname | grep -q "Abroad1"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Japan_Tokyo_D-/"`
                elif echo $beforefinalname | grep -q "Abroad2"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Japan_Okinawa_D-/"`
                elif echo $beforefinalname | grep -q "Abroad3"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Japan_Tokyo_D-/"`
                elif echo $beforefinalname | grep -q "Local4"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Hsinchu_Restaurant4_D-/"`
               elif echo $beforefinalname | grep -q "Local3"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Hsinchu_Restaurant1_D-/"`
               elif echo $beforefinalname | grep -q "Local5"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Hsinchu_Restaurant1_D-/"`
               elif echo $beforefinalname | grep -q "Local1"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Hsinchu_Restaurant2_D-/"`
               elif echo $beforefinalname | grep -q "Local2"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Hsinchu_Beach1_D-/"`
               elif echo $beforefinalname | grep -q "OutCity1"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Kenting_D-/"`
               elif echo $beforefinalname | grep -q "OutCity2"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Pingtung_D-/"`
               elif echo $beforefinalname | grep -q "OutCity3"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Ilan_D-/"`
               elif echo $beforefinalname | grep -q "OutCity4"
                then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Kaohsiung_D-/"`
               elif echo $beforefinalname | grep -q "OutCity5"
               then
                    beforefinalname=`echo $beforefinalname | sed -E "s/_L-.*?_D-............_/_$gpsstring/"`
                    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-/_L-Taiwan_Ilan_D-/"`
               fi
               #echo "sub file $sub_file  "
               #echo "new_file $beforefinalname"
            fi
            #echo "sub file $sub_file  "
            #echo "new_file $beforefinalname"
            #sleep 1
            fivedigtotalcount=`printf "%05d\n" $totalcount`
            beforefinalname=$fivedigtotalcount$beforefinalname

                mv $sub_file "temp.jpg"
                mv "temp.jpg" $beforefinalname
                #echo $sub_file $beforefinalname
            Real_Count=$((Real_Count+1))
            totalcount=$((totalcount+1))
        fi 
    done 

}

function Inject_EXIF(){
    local input_file=$1
    local GPS=$2
    local DATE=$3
    local gpscount=$4
    local namecount=$5
   
    gpscount=$[ $gpscount % 300 ]

    randomgps=$RANDOM
    randomgps=$[ $randomgps % 7 ]
    
    randomaddminus=$RANDOM
    randomaddminus=$[ $randomaddminus % 4 ]

    la=`echo $GPS |awk -F '-' '{print $2}'`
        laDirection=`echo $GPS |awk -F '-' '{print $2}'`
        lenla=${#la}
    if [ $lenla != 0 ]
    then
        lenlaMinus=$((lenla-1))
    fi
    la=${la:0:$lenlaMinus}
    laDirection=${laDirection:$lenlaMinus:1}

    lo=`echo $GPS |awk -F '-' '{print $3}'`
    loDirection=`echo $GPS |awk -F '-' '{print $3}'`
    lenlo=${#lo}
    if [ $lenlo != 0 ]
    then
        lenloMinus=$((lenlo-1))
    fi
    lo=${lo:0:$lenloMinus}
    loDirection=${loDirection:$lenloMinus:1}

    #echo "L  $la   $lo  $laDirection $loDirection" 
    Dirdate=`echo $DATE |awk -F '-' '{print $2}'`
    lendate=${#Dirdate}
    Year=${Dirdate:0:4}
    Mon=${Dirdate:4:2}
    Day=${Dirdate:6:2}
    hour=${Dirdate:8:2}
    min=${Dirdate:10:2}
    DATETIME="$Year-$Mon-$Day $hour:$min:00"
    #echo $DATETIME

    CalDateTime=$(date +%s -d "$DATETIME")
    #echo $CalDateTime
    PlusTwoMin=$((2*60*$gpscount))
    FinalDateTime=$(($CalDateTime+$PlusTwoMin))
    returndatetime=$(date +%Y%m%d%H%M -d "1970-01-01 UTC $FinalDateTime seconds")
    FinalDateTime=$(date +%Y-%m-%d\ %H:%M:%S -d "1970-01-01 UTC $FinalDateTime seconds")
    #echo $FinalDateTime
    if [ $randomaddminus == 0 ]
    then
        gpslo=$(echo "scale=8;$lo-($gpscount/100000)-($randomgps/100000)"| bc)
        gpsla=$(echo "scale=8;$la+($gpscount/100000)+($randomgps/100000)"| bc)
    elif [ $randomaddminus == 1 ]
    then
        gpslo=$(echo "scale=8;$lo+($gpscount/100000)+($randomgps/100000)"| bc)
        gpsla=$(echo "scale=8;$la+($gpscount/100000)+($randomgps/100000)"| bc)
    elif [ $randomaddminus == 2 ]
    then
        gpslo=$(echo "scale=8;$lo+($gpscount/100000)+($randomgps/100000)"| bc)
        gpsla=$(echo "scale=8;$la-($gpscount/100000)-($randomgps/100000)"| bc)
    elif [ $randomaddminus == 3 ]
    then
        gpslo=$(echo "scale=8;$lo-($gpscount/100000)-($randomgps/100000)"| bc)
        gpsla=$(echo "scale=8;$la-($gpscount/100000)-($randomgps/100000)"| bc)
    fi
    if [ $lo ]
    then
        echo "L-"$gpsla$laDirection-$gpslo$loDirection"_D-"$returndatetime"_"
        Create_EXIF_CSV $input_file "$FinalDateTime" $gpsla $gpslo $laDirection $loDirection
    else
        echo "L-_D-"$returndatetime"_"
        Create_EXIF_CSV $input_file "$FinalDateTime" " " " " $laDirection $loDirection
    fi
        $EXIFTools -exif:all= -csv=/tmp/exif_tmp.csv $input_file
    rm -f $input_file"_original"
    #rm -f "/tmp/exif_tmp.csv"

}

function Create_EXIF_CSV(){
    file_name=$1
    OrignalDate=$2
    GPSLa=$3
    GPSLo=$4
    GPSLaD=$5
    GPSLoD=$6

## OrignalData  =  2013:11:13 13:07:18,
## GPSLa,GPSLo "24 deg 58' 45.22"" N","121 deg 32' 44.71"" E",
    msg1="SourceFile,DateTimeOriginal,CreateDate,GPSLatitudeRef,GPSLongitudeRef,GPSAltitudeRef,GPSProcessingMethod,GPSAltitude,GPSLatitude,GPSLongitude,GPSPosition"
    msg2="$file_name,$OrignalDate,$OrignalDate,North,East,Above Sea Level,ASCII,0 m Above Sea Level,\"$GPSLa\"\" $GPSLaD\",\"$GPSLo\"\" $GPSLoD\",\"$GPSLa\"\" $GPSLaD\",\" $GPSLo\"\" $GPSLoD\""
	echo $msg1 > /tmp/exif_tmp.csv
	echo $msg2 >> /tmp/exif_tmp.csv

}

echo "Start Path = $Target_Path,  Total Count = $Total_Count "

do_change $Target_Path 0 " "

#Inject_EXIF 123 "L-35.658761N-139.777122E" "D-201312040900" 1 

#gpsstring="L-35.608493N-139.685529E_D-201306191910_"
#beforefinalname="_Scenario_Abroad_Abroad3_L-35.608488N-139.685524E_D-201306191900_G1_G2_6.jpg"
#    beforefinalname=`echo $beforefinalname | sed  -E "s/_L-.*?_D-............_/_$gpsstring/"`

#echo $beforefinalname


