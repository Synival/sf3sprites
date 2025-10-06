#!/bin/bash

# SF3 resource locations
DIR_SCENARIO1="D:"
DIR_SCENARIO2="E:"
DIR_SCENARIO3="F:"
DIR_PREMIUM_DISK="G:"
DIR_ALL_DISCS="$DIR_SCENARIO1 $DIR_SCENARIO2 $DIR_SCENARIO3 $DIR_PREMIUM_DISK"

# Universal parameters for chrtool.exe
CHRTOOL_PARAMS="--sprite-dir=resources/sprites --spritesheet-dir=resources/spritesheets --frame-hash-lookups-file=resources/FrameHashLookups.json"

# Extract spritesheets
./chrtool.exe $CHRTOOL_PARAMS extract-sheets $DIR_ALL_DISCS

# Extract CHR/CHP source per scenario
./chrtool.exe $CHRTOOL_PARAMS decompile $DIR_SCENARIO1 --output-dir=src/scenario1
./chrtool.exe $CHRTOOL_PARAMS decompile $DIR_SCENARIO2 --output-dir=src/scenario2
./chrtool.exe $CHRTOOL_PARAMS decompile $DIR_SCENARIO3 --output-dir=src/scenario3
./chrtool.exe $CHRTOOL_PARAMS decompile $DIR_PREMIUM_DISK --output-dir=src/premium-disk

echo
echo Done.
