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
PROJECTS="../../physics/*
../../memory/*
../../input/*
../../VGA/*
../../graphics/*"

cd main/VHDL

# Delete old symlinks
find . -type l | xargs rm;

# Create new symlinks
for directory in $PROJECTS; do
for file in `ls -d $directory -1`
do
	ln -s -r $file
	echo "Linked $file to main."
done
done
