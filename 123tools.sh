#!/bin/bash

#
# Name: 123tools.sh
#
# Author: Dr M. GUEDJ
#
# Description: 123tools.sh allows to install other programs on a Linux System.
#
# Version: 0.4
#
# Date: 12/11/2019
#
# License: MIT LICENSE 
# -- see the file MIT-LICENSE.txt
#

# is there a '~/.bashrc' file ?
if [ ! -e "$HOME/.bashrc" ]
then 
	echo "!: 123tools acts only over a Linux System having a .bashrc file."
	exit 1
fi


# is there any reference to the '~/.bash_aliases' file
# in the '~/.bashrc' file ?
var=$( cat $HOME/.bashrc | grep "~/.bash_aliases" )
if [ "$var" = "" ]
then 
	echo "!: 123tools acts only over a Linux session with a regular .bashrc file."
	exit 1
fi


# updates (the date) of the '~/.bash_aliases' file
# -- creates this file, if it does not exist
alias_file="$HOME/.bash_aliases"
touch "$alias_file"

# test the presence of a 'CONFIG.123' file
if [ ! -e "CONFIG.123" ]
then 
	echo "!: A CONFIG.123 file must be given in the current directory."
	exit 1
fi

# '~/.123'
# directory where the programs, installed with 123tools, are put
install_dir="$HOME/.123" 
if [ ! -e "$install_dir" ]
then
	mkdir $install_dir 
	echo "creation of $install_dir:  [OK]"
fi

# adding of a directory for the considered project in the '.123/' directory
name=$(cat 'CONFIG.123' | grep ^name | sed "s/;/ /g" | awk '{ print $2 }')
if [ -e "$install_dir/$name" ]
then 
	echo "$install_dir/$name already exists."
	echo "Uninstall first \"$name\" from your system."
	echo "See if $install_dir/$name/UNINSTALL.sh exists."
	exit 1
fi

mkdir "$install_dir/$name"
cp "CONFIG.123" "$install_dir/$name"

# copy the files of our programm
cp * "$install_dir/$name"

# adding of the aliases  
cat 'CONFIG.123' | grep ^alias | sed "s/;/  /g" | awk '{ print $2" "$3" "$4 }' > _programs_ 
# add the aliases
while read line 
do 
	_alias=""
	_prog=""
	_run_with=""
	echo $line > _tmp_	
	
	for y in $(cat _tmp_ | awk '{print $1}')
	do
		_prog=$y
	done 
	
	for y in $(cat _tmp_ | awk '{print $2}')
	do
		_alias=$y
	done 

	for y in $(cat _tmp_ | awk '{print $3}')
	do
		_run_with=$y
	done 

	rm _tmp_

	echo "alias $_alias='$_run_with $install_dir/$name/$_prog'" >> "$alias_file"
done < _programs_ 

rm _programs_ 

# let us remark one not operates modification in the PATH variable 

# ---------- Generation of the UNINSTALL.sh file 
uninstall_file="$install_dir/$name/UNINSTALL.sh"
touch $uninstall_file
install_dir="$HOME/.123" 
name=$(cat "CONFIG.123" | grep ^name | sed "s/;/ /g" | awk '{ print $2 }')
echo "rm -r $install_dir/$name" >> $uninstall_file

echo "cat $HOME/.bash_aliases | grep -v $install_dir/$name > _tmp_" >> $uninstall_file
echo "cat _tmp_ > $HOME/.bash_aliases" >> $uninstall_file

echo "echo Uninstallation of \"$name\": [OK]" >> $uninstall_file

