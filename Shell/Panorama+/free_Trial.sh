#!/bin/bash 

## Please input your target folder to start  
## ./free_Trial.sh /home/Panorama+/Panorama_Free_Try_Folder/2013-w17/

Target_Path=$1
Target_Report=`pwd`"/Report/free_trial_report.txt"

if [ ! -f $Target_Report ]
then 
	touch $Target_Report
else 
	echo "" > $Target_Report
fi

echo "Target Path  = "$Target_Path

## Get Folder List (first layer)
User_Dirs=`ls -l $Target_Path | egrep '^d' | awk '{print $9}'`

Total_Count=0

## Print Folder List (first lyaer)
for DIR_User in $User_Dirs 
do 
	Folder_Name=${DIR_User}
	User_Name=`echo ${DIR_User} | cut -d "-" -f 1`
	echo "Folder Name ==> "$Folder_Name
	echo "User Name ==> "$User_Name
	
	## Get folder list (second layer)
	User_Dirs_Detail=`ls -l $Target_Path/$Folder_Name | egrep '^d' | awk '{print $9}'`
	Count_Capture=0
	for DIR_User_Second in $User_Dirs_Detail
	do 
		Folder_Name_User=${DIR_User_Second}

		if [ -f $Target_Path/$Folder_Name/$Folder_Name_User/TSHpano.jpg ]
		then 
			Result_Ready="OK"
			Total_Count=$(($Total_Count+1))
		else
			Result_Ready="Fail"
			Total_Count=$(($Total_Count+1))
		fi
		
		echo -n "  $Result_Ready  "		

		echo "  Folder Name for User ==> $Folder_Name_User "
		Count_Capture=$(($Count_Capture+1))

		#echo $Target_Report
		#echo "$Total_Count $User_Name $Folder_Name_User" 
		echo "$Total_Count $Result_Ready $User_Name $Folder_Name_User" >> $Target_Report
		

	done 
	echo "Counts of capture for $User_Name is $Count_Capture"
done


