#!/bin/bash
echo "" > /tmp/kcsirtFindScan.txt
find / -name '*log4j*.jar' -print0 2>/dev/null -print0 | while read -d $'\0' log4j; do
	echo -en "${log4j}: "$(unzip -p "${log4j}" | strings | grep -Po '^Implementation-Version:\s+([0-9\.]+)' | awk '{ print $NF }')"\n" >> /tmp/kcsirtFindScan.txt
done
exit 0
