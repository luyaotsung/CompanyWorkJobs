#!/bin/bash

## Value for all use 
File_Name="data.txt"
QR_Target_Folder="target_qr"
VCF_Target_Folder="target_vcf"
Country_List="Tw En"

Get_User_Count()
{
        local rowN=$(cat $File_Name | wc | awk '{print $1}')
        echo "Row Number is ==> "$rowN
        return $rowN
}

Reset_Folder()
{
	local name=$1
	echo "Target Folder Name is ==> "$name
	if [ -d $name ]
	then
		#echo "QR Target Folder is existed"
		rm -rf $name
		mkdir $name
	else
		#echo "QR Target Folder is not existed"
		mkdir $name
	fi
}

#	## VCARD Sample ## 
#	BEGIN:VCARD
#	VERSION:3.0
#	FN:Eli Lu
#	N:Lu;Eli;;;
#	EMAIL;TYPE=INTERNET;TYPE=WORK:eli.lu@videace.com
#	TEL;TYPE=CELL:+0921623866
#	TEL;TYPE=WORK:+886227996809\,\,850
#	TEL;TYPE=WORK;TYPE=FAX:+886227996609
#	ADR;TYPE=WORK:;;9th Floor\, No.477\, TiDin Blvd.\, Sec.2\, Neihu District\,
#	  Taipei City 114\, Taiwan(R.O.C.);;;;
#	ORG:VideACE TECHNOLOGY CO. 
#	TITLE:Senior Manager
#	END:VCARD
## Value for vcf 
## 03, 04, 05, 06, 07, 12 need add more value 
VCF_CMD_01="BEGIN:VCARD"
VCF_CMD_02="VERSION:3.0"
VCF_CMD_03="FN:"
VCF_CMD_04="N:"
VCF_CMD_05="EMAIL;TYPE=INTERNET;TYPE=WORK:"
VCF_CMD_06="TEL;TYPE=CELL:+886"
VCF_CMD_07="TEL;TYPE=WORK:+886227996809\,\,"
VCF_CMD_08="TEL;TYPE=WORK;TYPE=FAX:+886227996609"
VCF_CMD_09_TW="ADR;TYPE=WORK:;;114台北巿內湖區堤頂大道二段477號9樓"
VCF_CMD_09_EN="ADR;TYPE=WORK:;;9th Floor\, No.477\, TiDin Blvd.\, Sec.2\, Neihu District\,"
VCF_CMD_10_EN="Taipei City 114\, Taiwan(R.O.C.);;;;"
VCF_CMD_11_TW="ORG:偉視科技股份有限公司"
VCF_CMD_11_EN="ORG:VideACE TECHNOLOGY CO."
VCF_CMD_12="TITLE:"
VCF_CMD_13="END:VCARD"

VCF_Generate_Country()
{
	local correct_row=$1
	local country=$2
	local Cell_Phone_Check=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 10 )

	if [ $country = "Tw" ]
	then 
		#echo "TW"

		## Full Name , First Name, Last Name
		local Full_Name=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 1 )
		if [ $correct_row = "1" ]
		then		
			local M_0_Name=$( echo $Full_Name | cut -c 2 )	
			local M_1_Name=$( echo $Full_Name | cut -c 3 )	
			local M_2_Name=$( echo $Full_Name | cut -c 4 )	
		else 

			local M_0_Name=$( echo $Full_Name | cut -c 1 )	
			local M_1_Name=$( echo $Full_Name | cut -c 2 )	
			local M_2_Name=$( echo $Full_Name | cut -c 3 )	
		fi
		local First_Name=$M_0_Name	
		local Last_Name=$M_1_Name$M_2_Name	
		local Nick_Name=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 2 )
		local Title=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 3 )
		local Department=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 5 )
		local VCF_CMD_09=$VCF_CMD_09_TW
		local VCF_CMD_11=$VCF_CMD_11_TW

	elif [ $country = "En" ]
	then
		#echo "EN"

		## Full Name, First Name , Last Name 
		local Full_Name=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 2 )
		local Last_Name=$( echo $Full_Name | cut -d ' ' -f 1 )
		local First_Name=$( echo $Full_Name | cut -d ' ' -f 2 )
		local Nick_Name=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 1 )
		local Title=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 4 )
		local Department=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 6 )
		local VCF_CMD_09=$VCF_CMD_09_EN
		local VCF_CMD_10=$VCF_CMD_10_EN
		local VCF_CMD_11=$VCF_CMD_11_EN
	else
		echo "Shit !! no one is match"
	fi 

	local EMail=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 7 )
	local File_Name_01=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 2 | cut -d ' ' -f 1 )
	local File_Name_02=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 2 | cut -d ' ' -f 2 )
	local File_Name_Final=$File_Name_01$File_Name_02
	local Extension_N=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 8 )
	local Cell=$( cat $File_Name | head -n $correct_row | tail -n 1 | cut -d ',' -f 9 | sed 's/^.//'  )
	
	echo "Full Name : "$Full_Name
	echo "First Name : "$First_Name
	echo "Last Name : "$Last_Name
	echo "End Name : "$End_Name 
	echo "Title : "$Title
	echo "Department : "$Department
	echo "E-Mail : "$EMail
	echo "File Name Final : "$File_Name_Final
	echo "Extension Number : "$Extension_N
	echo "Cell Phone Number : +886"$Cell
	echo "Cell Phone Check : "$Cell_Phone_Check
	echo ""

	local Target=$VCF_Target_Folder"/"$File_Name_Final$country".vcf"
	#echo "Target is : "$Target
	#echo ""

	## Start to write file 
	echo $VCF_CMD_01 >> $Target
	echo $VCF_CMD_02 >> $Target
	echo $VCF_CMD_03$Full_Name >> $Target
	echo $VCF_CMD_04$First_Name";"$Last_Name";;;" >> $Target
	echo "NICKNAME:"$Nick_Name >> $Target
	echo $VCF_CMD_05$EMail >> $Target
	if [ $Cell_Phone_Check == "0"  ]
	then 
		echo $VCF_CMD_06$Cell >> $Target
	fi 
	echo $VCF_CMD_07$Extension_N >> $Target
	echo $VCF_CMD_08 >> $Target
	echo $VCF_CMD_09 >> $Target
	if [ $country != "Tw" ]
	then 
		echo "  "$VCF_CMD_10 >> $Target
	fi
	echo $VCF_CMD_11 >> $Target
	echo $VCF_CMD_12$Title >> $Target
	echo $VCF_CMD_13 >> $Target
}

VCF_Generate()
{
	
	Get_User_Count
	local rowN=$?
	for (( row=1; row<=$rowN ; row=row+1 ))
	do
		for country in $Country_List
		do
			VCF_Generate_Country $row $country
		done
	done
}

## Value for QR code 
QR_Address="http://www.videace.com/BC"
QR_CMD=`which qrencode`

QR_Generate()
{
	Get_User_Count
	local rowN=$?
	for (( row=1; row<=$rowN ; row=row+1 ))
	do
		## Get real name data file
		real_name_01=$( cat $File_Name | head -n $row | tail -n 1 | cut -d ',' -f 2 | cut -d ' ' -f 1 )
		real_name_02=$( cat $File_Name | head -n $row | tail -n 1 | cut -d ',' -f 2 | cut -d ' ' -f 2 )
		real_name=$real_name_01$real_name_02
		echo "Real Name is " $real_name

		## start to generate qr picture
		for country in $Country_List
		do
			$QR_CMD -o $QR_Target_Folder/$real_name$country.png $QR_Address/$real_name$country.vcf
			# echo "Out File Name is ==> "$Target_Folder"/"$real_name$country".png"
			# echo "QR Address is ==> "$QR_Address"/"$real_name$country".vcf"
		done
	done
}

help_dump()
{
	echo "BusinessCard.sh qr/vcf"
}

case $1 in 
	qr)
		Reset_Folder $QR_Target_Folder
		QR_Generate	
		exit
		;;
	vcf)	
		Reset_Folder $VCF_Target_Folder
		VCF_Generate
		exit
		;;
	*)	help_dump
		exit
		;;
esac
