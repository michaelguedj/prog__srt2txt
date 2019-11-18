#!/bin/bash
##
## Author: Dr Michaël GUEDJ
## 
## Name: srt2txt
## 
## Description:
## ============
## ---- srt2txt.sh takes as argument a "srt" file
## ---- (commnoly used to encode subtitles)
## ---- srt2txt.sh outputs a ".txt" file whose the 
## ---- ---- content consists of the actual "human" readable part
## ---- ---- from the "srt" file
## ---- the name of the output file proceeds as follow
## ---- ---- if the input file is "foo.srt"
## ---- ---- then the output file is "foo_dialogs.txt"
##
## Version: 0.1
##
## Date: 18/11/2019
##
## License: MIT LICENSE 
## -- see the file MIT-LICENSE.txt
##
#
# General Documentation
# From: https://en.wikipedia.org/wiki/SubRip
# SubRip (SubRip Text) files are named with the extension .srt, and contain
# formatted lines of plain text in groups separated by a blank line.
# Subtitles are numbered sequentially, starting at 1. 
# The timecode format used is hours:minutes:seconds,milliseconds 
# with time units fixed to two zero-padded digits and fractions 
# fixed to three zero-padded digits (00:00:00,000). 
# The fractional separator used is the comma, since the program was written in France.
# 
#     A numeric counter identifying each sequential subtitle
#     The time that the subtitle should appear on the screen, followed by --> and the time it should disappear
#     Subtitle text itself on one or more lines
#     A blank line containing no text, indicating the end of this subtitle
# 

# ----  ----  ---- USAGE'S PART

function usage 
{
	echo "Usage: srt2txt <some_srt_file>"
	echo "--> generates a text file corresponding" 
	echo "    to the \"human\" readable part"
	echo "    of the srt (subtitle) files given in argument."

	exit 1
}

if [ $# -lt 1 ]
then 
	echo "!: 1 argument is required"
	usage
fi

if [ ! -e $1 ]
then
	echo "!: \"$1\" does not exist"
	usage
fi

if [ ! -f $1 ]
then 
	echo "!: \"$1\" is not a common file"
	if [ -d $1 ]
	then 
		echo "--> \"$1\" is detected as a directory"
	fi
	usage
fi



# ----  ----  ---- NAMING OF THE RESULTS FILE 

results_file=""
if [[ $1 =~ ".srt" ]]
then
	name=$(echo $1 | sed "s/\.srt$//")
	results_file=$name".txt"
else
	echo "Warning: the input file (\"$1\") does not have the extension \".srt\""
	results_file=$1".txt"
fi


# ----  ----  ---- ACTUAL TRANSFORMATIONS

# because of something not wanted on the top of the file
# from: https://unix.stackexchange.com/questions/381230/how-can-i-remove-the-bom-from-a-utf-8-file
# If you're not sure if the file contains a UTF-8 BOM, 
# then this (assuming the GNU implementation of sed) 
# will remove the BOM if it exists, or make no changes if it doesn't.
#
# sed '1s/^\xEF\xBB\xBF//' < orig.txt > new.txt
# You can also overwrite the existing file with the -i option:
# sed -i '1s/^\xEF\xBB\xBF//' orig.txt
# -->
sed -i '1s/^\xEF\xBB\xBF//' $1
#


cat $1 | grep -v ".*[-][-]>.*" | sed "s/<?*>//g" | sed "s/<\/?*>//g" | grep -v "^[0-9]" > $results_file 
echo "srt2txt operation: [OK]"
echo "Resulting file: \"$results_file\"".



# ----  ----  ---- SOME EXPLANATIONS

#====================================================================
#		grep -v ".*[-][-]>.*" 
#====================================================================
# Removing of the lines of the type "00:20:41,150 --> 00:20:45,109"
# i.e. [time of beginning] --> [time of ending]


#====================================================================
# 		sed "s/<?*>//g" | sed "s/<\/?*>//g" |
#====================================================================
# 		
#		sed "s/<?*>//g" 
# Removing of the tags of the form <foo> -- i.e. the start tags 
#
#		sed "s/<\/?*>//g" 
# Removing of the tags of the form </foo> -- i.e. end tags 
#

#====================================================================
# 		grep -v "^[0-9]" 
#====================================================================
# Removing of the lines containing only a number

