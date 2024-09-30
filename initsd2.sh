#!usr/bin/env bash

cat <<HERE

HERE

SDCARD_PATH=/media/user/bootfs
CONFIG=config.txt
CMDLINE=cmdline.txt

date

# detect SD card
function detectSD(){
	while true;do
	if [ -d ${SDCARD_PATH} ];then
		echo "detect SD card!"
		return
	fi
	sleep 1
done
}

echo before detectSD
detectSD
echo after detectSD

# find cmdline.txt
function detectCMDLINE(){
	sleep 1
	if [ -f ${SDCARD_PATH}/${CMDLINE} ];then
		# echo -n "detect cmdline.txt!"
		echo 0 # find
	else
		echo 1 # no found
	fi
}

#echo "[cmdine.txt] `detectCMDLINE`"
isCMDLINE=`detectCMDLINE`

# modify cmdline.txt (192.168.81.1 -> ...)
IPADDR=192.168.81.1
if [ $isCMDLINE -eq 0 ];then
	# fgrep -o "${IPADDR}" "${SDCARD_PATH}/${CMDLINE}"
	sed -i "s/${IPADDR}/111.111.111.111/" "${SDCARD_PATH}/${CMDLINE}"
	
	if [ $? -eq 0 ];then
		echo "${CMDLINE} modify"
	else
		echo "${CMDLINE} no modify"
	fi
fi

# unmount /media/user/bootfs
umount ${SDCARD_PATH}
echo "SDcard detachable"

# config.txt
