#!/bin/bash
#createusers.sh
INPUT=users.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read name grp user
do
	useradd -c "$name" -d /home/$user -G $grp $user
done < $INPUT
IFS=$OLDIFS