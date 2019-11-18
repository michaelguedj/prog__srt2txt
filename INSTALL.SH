#!/bin/bash


if [ -e ARCHIVES ]
then 
	rm -r ARCHIVES
fi

bash 123tools.sh

if [ "$?" = 0 ]
then
	echo "Installation of srt2txt: [OK]"
fi
