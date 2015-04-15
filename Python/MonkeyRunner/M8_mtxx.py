import os
from com.android.monkeyrunner import MonkeyRunner, MonkeyDevice
#''' import MonkeyRunner 

M8=MonkeyRunner.waitForConnection(5,"HT42JWM00259")
#''' Wait for connection Wait Time ex: 10  mean 10 Second
# M8.installPackage("D:\\adb\\apk\PhotoPortal_20140408\\Tiger_master_branch_only-arm-debug-unaligned.apk")
#''' Install apk if success it will return true and print on screen
#shell(" content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0")

for fileindex in os.listdir("C:\\Android\\adt-bundle-windows-x86_64-20131030\\sdk\\tools\\forg\\"):

	os.system("adb.exe shell am force-stop com.mt.mtxx.mtxx")
	os.system("adb.exe shell rm -f /sdcard/100MEDIA/*")
	os.system("adb.exe push forg/"+fileindex+" /sdcard/100MEDIA/")
	print("update photo "+fileindex+" OK!")
	os.system("adb.exe shell am broadcast -a android.intent.action.MEDIA_MOUNTED -d file://sdcard/100MEDIA/")
	MonkeyRunner.sleep(9)
	M8.startActivity(component="com.mt.mtxx.mtxx/com.meitu.mtxx.MainActivity")
	## start activity name with package name and full activity name
	MonkeyRunner.sleep(5)
	####all photo 
	##click  edit photo
	M8.touch(340, 505, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("edit OK!")
	##click album
	M8.touch(145, 481, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("album OK!")
	##click first photo
	M8.touch(135, 267, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(5)
	print("first photo OK!")
	##click auto enhance
	M8.touch(157, 1722, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("auto enhance OK!")
	##click deforg
	M8.touch(1023, 1677, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("deforg OK!")
	##click check 
	M8.touch(988, 100, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("check OK!")
	##click save
	M8.touch(906, 74, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("save OK!")
	##click save icon
	M8.touch(537, 575, M8.DOWN_AND_UP)
	MonkeyRunner.sleep(2)
	print("save icon OK!")

#'''