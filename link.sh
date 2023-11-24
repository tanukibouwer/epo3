#!/bin/bash

# Links all VHDL files in each project to the main project.
# Removes all existing links beforehand.
# Only works on Linux. (like the x2go environment)
# Make sure to run this in the folder where it's located.
#
# Usage:
# cd [path to epo3 folder]
# sh link.sh

# To add your project to the main project, add to the line below.
PROJECTS=$2

rm -rf $1 
cp -r template $1

cd $1/VHDL

# Create new symlinks
for directory in $PROJECTS; do
for file in `ls -d $directory -1`
do
	ln -s -r $file
	echo "Linked $file to $1."
done
done
