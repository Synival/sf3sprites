#!/bin/bash

# =====================================================================================================================
# Settings
# =====================================================================================================================

# SF3 original file locations (as Windows path)
DIR_SCENARIO1_WIN="game-files/scenario1"
DIR_SCENARIO2_WIN="game-files/scenario2"
DIR_SCENARIO3_WIN="game-files/scenario3"
DIR_PREMIUM_DISK_WIN="game-files/premium-disk"

# Universal parameters for chrtool.exe
CHRTOOL=./chrtool.exe
CHRTOOL_PARAMS="--sprite-dir=resources/sprites --spritesheet-dir=resources/spritesheets --frame-hash-lookups-file=resources/FrameHashLookups.json"

# =====================================================================================================================
# Internals
# =====================================================================================================================

DIR_ALL_DISCS_WIN="$DIR_SCENARIO1_WIN $DIR_SCENARIO2_WIN $DIR_SCENARIO3_WIN $DIR_PREMIUM_DISK_WIN"

# Extract spritesheets
$CHRTOOL $CHRTOOL_PARAMS extract-sheets $DIR_ALL_DISCS_WIN

# Extract CHR/CHP source per scenario
$CHRTOOL $CHRTOOL_PARAMS decompile $DIR_SCENARIO1_WIN --output-dir=src/scenario1
$CHRTOOL $CHRTOOL_PARAMS decompile $DIR_SCENARIO2_WIN --output-dir=src/scenario2
$CHRTOOL $CHRTOOL_PARAMS decompile $DIR_SCENARIO3_WIN --output-dir=src/scenario3
$CHRTOOL $CHRTOOL_PARAMS decompile $DIR_PREMIUM_DISK_WIN --output-dir=src/premium-disk

echo
echo Done.
