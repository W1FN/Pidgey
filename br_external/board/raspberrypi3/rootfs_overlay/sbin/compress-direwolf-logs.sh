#!/bin/sh

SECONDS_PER_DAY=$(( 24 * 60 * 60 ))
COMPRESS_BEFORE_DATE=$(( $(date +%s) - SECONDS_PER_DAY * 2 ))

for log_file in /var/log/direwolf/20*.log
do
    log_date=$(date +%s -d$(basename -s.log $log_file))
    if [ $log_date -lt $COMPRESS_BEFORE_DATE ]
    then
        echo "Compressing $log_file"
        gzip $log_file
    fi
done
