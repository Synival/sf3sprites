#!/bin/bash

# Clean existing DFR files.
rm dfrs/*/*.DFR

# Linux paths are necessary for 'diff'...
DIR_SCENARIO1=/mnt/d
DIR_SCENARIO2=/mnt/e
DIR_SCENARIO3=/mnt/f
DIR_PREMIUM_DISK=/mnt/g

# ...and Windows paths are necessary for 'dfrtool.exe'.
DIR_SCENARIO1_WIN="D:"
DIR_SCENARIO2_WIN="E:"
DIR_SCENARIO3_WIN="F:"
DIR_PREMIUM_DISK_WIN="G:"

# Produces DFRs, with the following inputs:
#   DIR_NEW:      where the new CHP/CHR files are located
#   DIR_ORIG:     where the original CHP/CHR files are located (Linux path)
#   DIR_ORIG_WIN: where the original CHP/CHR files are located (Windows path)
#   DIR_DFRS:     whee DFR files should be outputted
function make_dfrs() {
    mkdir -p $DIR_DFRS
    for FILE in $DIR_NEW/*; do
        echo $FILE
        BASE_FILE=`echo $FILE | sed "s/.*\///"`
        DISC_FILE="$DIR_ORIG/$BASE_FILE"
        DIFF=`diff $FILE $DISC_FILE`
        if [[ ! -z "$DIFF" ]]; then
            echo "  Generating DFR..."
            DISC_FILE_WIN="$DIR_ORIG_WIN/$BASE_FILE"
            ./dfrtool.exe create $DISC_FILE_WIN $FILE > $DIR_DFRS/$BASE_FILE.DFR
        fi
    done
}

# Scenario 1 DFRs
DIR_NEW=output/scenario1
DIR_ORIG=$DIR_SCENARIO1
DIR_ORIG_WIN=$DIR_SCENARIO1_WIN
DIR_DFRS=dfrs/scenario1
make_dfrs

# Scenario 2 DFRs
DIR_NEW=output/scenario2
DIR_ORIG=$DIR_SCENARIO2
DIR_ORIG_WIN=$DIR_SCENARIO2_WIN
DIR_DFRS=dfrs/scenario2
make_dfrs

# Scenario 3 DFRs
DIR_NEW=output/scenario3
DIR_ORIG=$DIR_SCENARIO3
DIR_ORIG_WIN=$DIR_SCENARIO3_WIN
DIR_DFRS=dfrs/scenario3
make_dfrs

# Premium Disk DFRs
DIR_NEW=output/premium-disk
DIR_ORIG=$DIR_PREMIUM_DISK
DIR_ORIG_WIN=$DIR_PREMIUM_DISK_WIN
DIR_DFRS=dfrs/premium-disk
make_dfrs

echo "Done."
