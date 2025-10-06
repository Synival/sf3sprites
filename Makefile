# =====================================================================================================================
# Settings
# =====================================================================================================================

# SF3 original file locations (as Windows path)
DIR_SCENARIO1_WIN="game-files/scenario1"
DIR_SCENARIO2_WIN="game-files/scenario2"
DIR_SCENARIO3_WIN="game-files/scenario3"
DIR_PREMIUM_DISK_WIN="game-files/premium-disk"

# Universal parameters for chrtool.exe
CHRTOOL = ./chrtool.exe
CHRTOOL_PARAMS = --sprite-dir=resources/sprites --spritesheet-dir=resources/spritesheets --frame-hash-lookups-file=resources/FrameHashLookups.json

# =====================================================================================================================
# Internals
# =====================================================================================================================

SRC_PATH = src
OUT_PATH = output

SRC_SCENARIO1 = $(shell find ./$(SRC_PATH)/scenario1 -type f -iname "*.sf3chr" -o -iname "*.sf3chp")
SRC_SCENARIO2 = $(shell find ./$(SRC_PATH)/scenario2 -type f -iname "*.sf3chr" -o -iname "*.sf3chp")
SRC_SCENARIO3 = $(shell find ./$(SRC_PATH)/scenario3 -type f -iname "*.sf3chr" -o -iname "*.sf3chp")
SRC_PREMIUM_DISK = $(shell find ./$(SRC_PATH)/premium-disk -type f -iname "*.sf3chr" -o -iname "*.sf3chp")

SRC = $(SRC_SCENARIO1) $(SRC_SCENARIO2) $(SRC_SCENARIO3) $(SRC_PREMIUM_DISK)

OBJ = $(shell echo " $(SRC) " \
    | sed "s/ \.\/$(SRC_PATH)\// .\/$(OUT_PATH)\//g" \
    | sed "s/\.SF3CHR /.CHR /Ig" \
    | sed "s/\.SF3CHP /.CHP /Ig" \
)

DIR_SCENARIO1_WIN_SED=$(shell echo $(DIR_SCENARIO1_WIN) | sed "s/\//\\\\\//g")
DIR_SCENARIO2_WIN_SED=$(shell echo $(DIR_SCENARIO2_WIN) | sed "s/\//\\\\\//g")
DIR_SCENARIO3_WIN_SED=$(shell echo $(DIR_SCENARIO3_WIN) | sed "s/\//\\\\\//g")
DIR_PREMIUM_DISK_WIN_SED=$(shell echo $(DIR_PREMIUM_DISK_WIN) | sed "s/\//\\\\\//g")

all: $(OBJ)
	@echo Done.

scenario1:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(SRC_SCENARIO1) --output-dir=$(OUT_PATH)/scenario1 # TODO: --padding-from-dir

scenario2:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(SRC_SCENARIO2) --output-dir=$(OUT_PATH)/scenario2 # TODO: --padding-from-dir

scenario3:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(SRC_SCENARIO3) --output-dir=$(OUT_PATH)/scenario3 # TODO: --padding-from-dir

premium-disk:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(SRC_PREMIUM_DISK) --output-dir=$(OUT_PATH)/premium-disk # TODO: --padding-from-dir

recompile: scenario1 scenario2 scenario3 premium-disk
	@echo Done.

$(OUT_PATH)/%.CHR: $(SRC_PATH)/%.SF3CHR
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@

$(OUT_PATH)/%.CHP: $(SRC_PATH)/%.SF3CHP
	$(eval ORIG_FILE=$(shell echo $@ \
		| sed "s/^$(OUT_PATH)\/scenario1\//$(DIR_SCENARIO1_WIN_SED)\//" \
		| sed "s/^$(OUT_PATH)\/scenario2\//$(DIR_SCENARIO2_WIN_SED)\//" \
		| sed "s/^$(OUT_PATH)\/scenario3\//$(DIR_SCENARIO3_WIN_SED)\//" \
		| sed "s/^$(OUT_PATH)\/premium-disk\//$(DIR_PREMIUM_DISK_WIN_SED)\//") \
	)
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@ --padding-from=$(ORIG_FILE)

clean:
	@echo Removing *.CHR, *.CHP from $(OUT_PATH)...
	@rm -f $(OBJ)
	@echo Done.
