#!/bin/bash

##
## exiftool  -GPSLongitude="7.422809"  -GPSLatitude="48.419973" IMAG0083.jpg 
##

EXIFTools=`which exiftool`

Source_Paht=`pwd`

Dir_List=`ls -l $Source_Path | egrep '^d' | awk '{print $9}'`

for dir_name in $Dir_List
do 
	#echo $dir_name
	
	filename=$Source_Paht"/menu.txt"
	exec < $filename
	while read line
	do
		
		#echo $line
		line_array=(${line// / })
		get_Folder_Name=${line_array[0]}
		get_Latitude=${line_array[1]}
		get_Longitude=${line_array[2]}
		get_La_Ref=${line_array[3]}		
		get_Lo_Ref=${line_array[4]}		
	
		#echo "Get _Folder Nmae ==> "$get_Folder_Name
		#echo "Get Longitude ==> "$get_Longitude
		#echo "Get Latitude ==> "$get_Latitude

		if [ $dir_name = $get_Folder_Name ]
		then 
			Real_Longitude=$get_Longitude
			Real_Latitude=$get_Latitude
			Real_Lo_Ref=$get_Lo_Ref
			Real_La_Ref=$get_La_Ref
		fi 
	done	
	echo "Real Foder ==> "$dir_name
	echo "Real Longitude ==> "$Real_Longitude
	echo "Real Latitude ==> "$Real_Latitude 

	File_List=`ls -l $Source_Path"$dir_name" | egrep '^-' | awk '{print $9}'`
	for file_name in $File_List
	do
		#echo "  ## $EXIFTools -GPSLongitude=$Real_Longitude -GPSLatitude=$Real_Latitude $Source_Path$dir_name/$file_name" 
		#$EXIFTools -GPSLongitude="$Real_Longitude" -GPSLatitude="$Real_Latitude" $Source_Path$dir_name"/"$file_name 
		$EXIFTools -GPSLongitude=$Real_Longitude -GPSLatitudeRef=$Real_La_Ref -GPSLatitude=$Real_Latitude -GPSLongitudeRef=$Real_Lo_Ref -GPSAltitudeRef=above  $Source_Path$dir_name"/"$file_name 
	
	done 
done 

