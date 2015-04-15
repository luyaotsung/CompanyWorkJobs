#!/bin/bash 

Service=$1
Config=$2 

CMD_Grep=`which grep`
CMD_Cut=`which cut`
CMD_Curl=`which curl`
CMD_D2U=`which dos2unix`
CMD_Bash=`which bash`
CMD_Cat=`which cat`


HTC_Token=""

## Step 2 : Get HTC Token 

echo "Step 2 ==> Start to get HTC Session Token "

CMD_Step_2="$CMD_Curl -k -v -X POST \
	-H 'X-Htc-Application-Id: 1' \
  	-H 'X-Htc-Rest-Api-Key: \${REST_API_KEY}' \
  	-H 'X-Htc-Device-Id: \${DEVICE_ID}' \
  	-H 'Content-Type: application/json' \
  	-d '[ `cat $Config` ]' \
	https://xdsi.sta.pp.aiqidii.com:8081/api/user \
	> Step_2.tmp.out 2>&1 "
echo $CMD_Step_2 > CMD_Step_2.out
$CMD_Bash ./CMD_Step_2.out

## Dos to Unis 
$CMD_D2U Step_2.tmp.out > /dev/null 2>&1 
HTC_Token=`$CMD_Cat Step_2.tmp.out | grep "X-Htc-Session-Token" | cut -d : -f 2 | tr -d ' '`

echo "Step 2 ==> Token : $HTC_Token "


## Step 3 : Start Get Document ID List 

echo "Step 3 ==> Start to get Document ID List "

CMD_Step_3="$CMD_Curl -k -X POST -H 'X-Htc-Application-Id: 1' \
	-H 'X-Htc-Session-Token:$HTC_Token' \
	-H 'X-Htc-Device-Id: ' \
	-H 'Content-Type: application/json' \
	-d '[]' \
	https://xfe.sta.pp.aiqidii.com:8083/api/resource/crawl \
        > Step_3.tmp.out 2>&1 "
echo $CMD_Step_3 > CMD_Step_3.out
$CMD_Bash ./CMD_Step_3.out

## Step 4 : Get Document ID List 

echo "Step 4 ==> Get Document ID List "

CMD_Step_4="$CMD_Curl -k -X GET \
        -H 'X-Htc-Application-Id: 1' \
	-H 'X-Htc-Rest-Api-Key: \${REST_API_KEY}' \
        -H 'X-Htc-Session-Token:$HTC_Token' \
        -H 'Content-Type: application/json' \
	https://xdsi.sta.pp.aiqidii.com:8081/api/document/pull/pp \
        > Step_4.tmp.out 2>&1 "
echo $CMD_Step_4 > CMD_Step_4.out
$CMD_Bash ./CMD_Step_4.out 
$CMD_D2U Step_4.tmp.out > /dev/null 2>&1  
$CMD_Cat Step_4.tmp.out | $CMD_Grep  ": \[" | $CMD_Cut -d "\"" -f 2 > Step_4.final.out

## Step 5 : Get Content of Document 

echo "Step 5 ==> Start to get content of Document "

while read line 
do 
	echo "Step 5 ==> Document ID $line"
	
	Output=$Service"_"$line".tmp.out"

	CMD_Step_5="$CMD_Curl -k -X GET \
		-H 'X-Htc-Application-Id: 1' \
		-H 'X-Htc-Rest-Api-Key: \${REST_API_KEY}' \
		-H 'X-Htc-Session-Token:$HTC_Token' \
		-H 'Content-Type: application/json' \
		https://xdsi.sta.pp.aiqidii.com:8081/api/document/pull/pp \
		> $Output 2>&1 "
	echo $CMD_Step_5 > CMD_Step_5.out
	$CMD_Bash ./CMD_Step_5.out

done < "Step_4.final.out"

