#!/bin/bash

########################################################################################
# Code check differences between NEMO 4.0.4 rev.14075 (baseline Met Office nemo version) 
# vs sources code changes implemented over that branch. 
# 
# It compares a copy of the code revision to source code changes implemented on nemo.
#
# NEMO-4.0.4-UKMO-mirror-r14075 was copied (via fcm) from the MO repository at: 
# https://code.metoffice.gov.uk/trac/nemo/browser/NEMO/branches/UKMO/NEMO_4.0.4_mirror?rev=14075
#
# Source code changes implemented at the Met Office can also be 
# checked out via fcm from specific branches.
# Branches used in an RCS run are specified in the 
# 'nemo_sources' section of the '[...]/app/fcm_make_ocean/rose-app.conf'
# 
# ChatGPT was used for the syntax of some of this code; checked by JR
#
# Date 11/02/25
########################################################################################

# Directories
DIR_A="../AMM15/MY_SRCs/NEMO-4.0.4-UKMO-mirror-r14075/src/OCE" #Baseline code for MO development
DIR_B="<path>/<to>/<modifiedSRC>/OCE" # code containing src changes
DIR_C="./SRCdiff" # outdir to save files that were modified from DIR_A

# Ensure DIR_C exists
mkdir -p "$DIR_C"

# 1. Find files that exist in both directories but are different
for file in "$DIR_B"/*; do
    filename=$(basename "$file")
    
    if [ -f "$file" ]; then  # Only process files
        if [ -e "$DIR_A/$filename" ]; then
            if ! diff -q "$DIR_A/$filename" "$file" > /dev/null; then
                echo "Copying different file: $filename"
                cp "$file" "$DIR_C/"
            fi
        fi
    fi
done

# 2. Find files that are only in B and not in A
for file in "$DIR_B"/*; do
    filename=$(basename "$file")
    
    if [ -f "$file" ]; then  # Only process files
        if [ ! -e "$DIR_A/$filename" ]; then
            echo "Copying new file from B: $filename"
            cp "$file" "$DIR_C/"
        fi
    fi
done

# 3. Handle subdirectories recursively
for subdir in "$DIR_B"/*; do
    subdirname=$(basename "$subdir")

    if [ -d "$subdir" ]; then  # Process only directories
        if [ -d "$DIR_A/$subdirname" ]; then
            # Subdirectory exists in both A and B, compare files
            echo "Checking subdirectory: $subdirname"

            for subfile in "$subdir"/*; do
                subfilename=$(basename "$subfile")

                if [ -f "$subfile" ]; then
                    if [ -e "$DIR_A/$subdirname/$subfilename" ]; then
                        if ! diff -q "$DIR_A/$subdirname/$subfilename" "$subfile" > /dev/null; then
                            echo "Copying different file from subdirectory: $subfilename"
                            cp "$subfile" "$DIR_C/"
                        fi
                    else
                        echo "Copying new file from subdirectory B: $subfilename"
                        cp "$subfile" "$DIR_C/"
                    fi
                fi
            done
        else
            # Subdirectory exists only in B, copy all its files to C without keeping structure
            echo "Copying all files from new subdirectory: $subdirname"
            find "$subdir" -type f -exec cp {} "$DIR_C/" \;
        fi
    fi
done

echo "File differencing complete!"

