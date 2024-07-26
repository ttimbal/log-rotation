#!/bin/bash

YEAR=$1
MONTH=$2

if [[ -z $YEAR || -z $MONTH ]]
then
        YEAR=$(date +"%Y")
	MONTH=$(date +"%m")
fi

LOGS_PATH="/home/timbal/taller/logs"
COMPRESS_PATH="/home/timbal/taller/daily-logs"

REMOTE_IP="192.168.0.22"
REMOTE_USER="timbal2"
REMOTE_PATH="/home/timbal2/taller"
SSH_KEY_NAME="/home/timbal/taller/scripts/timbal2-server"

SERVICES_NAME=$(ls $COMPRESS_PATH)

for SERVICE in $SERVICES_NAME
do
	LOCAL_FILES="${COMPRESS_PATH}/${SERVICE}/*"
	FILE_COUNT=$(ls -1p $COMPRESS_PATH/$SERVICE |  grep -E "${YEAR}${MONTH}[0-9]+.tar.gz" | wc -l)
	if [ ! "$FILE_COUNT" -gt 0 ]
	then
		echo "Logs not found in ${COMPRESS_PATH}/${SERVICE} for ${YEAR}-${MONTH}"
		continue
	fi

	DEST_FOLDER="${REMOTE_PATH}/${SERVICE}/${YEAR}/${MONTH}"
	ssh -i $SSH_KEY_NAME $REMOTE_USER@$REMOTE_IP "mkdir -p $DEST_FOLDER"


	FILES_TO_SEND=$(ls -1p $COMPRESS_PATH/$SERVICE |  grep -E "${YEAR}${MONTH}[0-9]+.tar.gz")
	for FILE in $FILES_TO_SEND
	do
		scp -i $SSH_KEY_NAME $COMPRESS_PATH/$SERVICE/$FILE $REMOTE_USER@$REMOTE_IP:$DEST_FOLDER
		rm ${COMPRESS_PATH}/${SERVICE}/$FILE 2>/dev/null
	done



	echo "Logs sent to remote server and deleted from local"
done

