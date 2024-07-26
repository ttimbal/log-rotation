#!/bin/bash

YEAR=$1
MONTH=$2
DAY=$3

if [[ -z $YEAR || -z $MONTH || -z $DAY ]]
then
        DATE=$(date +"%Y%m%d%H%M%S")
else
        TIME=$(date +"%H:%M:%S")
        DATE=$(date -d "$YEAR-$MONTH-$DAY $TIME" +"%Y%m%d%H%M%S")
fi


LOGS_PATH="/home/timbal/taller/logs"
COMPRESS_PATH="/home/timbal/taller/daily-logs"

SERVICES_NAME=$(ls $LOGS_PATH)

for SERVICE in $SERVICES_NAME
do
	LOG_FILE=$(ls "$LOGS_PATH/$SERVICE" | head -n 1 | awk '{sub(/\.log/, ""); print}')
	if [ ! -d "$COMPRESS_PATH/$SERVICE" ]
	then
		mkdir -p "$COMPRESS_PATH/$SERVICE"
	fi

	COMPRESS_LOG_NAME="${LOG_FILE}_${DATE}.tar.gz"
	tar -czvf "$COMPRESS_PATH/$SERVICE/$COMPRESS_LOG_NAME" -C "$LOGS_PATH/$SERVICE" "$LOG_FILE.log" > /dev/null 2>&1

	echo $COMPRESS_LOG_NAME
done
