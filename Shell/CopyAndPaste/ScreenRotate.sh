#!/system/bin/sh

Get_Orientation()
{
    #Orientation=`dumpsys display | grep "mCurrentOrientation" | cut -d '=' -f 2`
    Orientation=`dumpsys display | grep "mCurrentOrientation"`
    export $Orientation
}

Change_Orientation()
{
    ## Landscape  3
    ## Poratit    0
    Rotate=$1
    content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:$Rotate
}

Locker_Orientation()
{
    #  $Switch  = 0  lock
    #  $Switch  = 1  unlock
    Switch=$1
    content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:$Switch
}



Get_Orientation
#echo "current =>  $mCurrentOrientation"
Locker_Orientation 0
if [ $mCurrentOrientation == "0" ]
then

    Change_Orientation 3
    Change_Orientation 0
else

    Change_Orientation 0
    Change_Orientation 3

fi
Locker_Orientation 1
