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
CHRTOOL_COMPILE_PARAMS=--optimize-sectors

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
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(CHRTOOL_COMPILE_PARAMS) $(SRC_SCENARIO1) --output-dir=$(OUT_PATH)/scenario1 # TODO: --padding-from-dir

scenario2:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(CHRTOOL_COMPILE_PARAMS) $(SRC_SCENARIO2) --output-dir=$(OUT_PATH)/scenario2 # TODO: --padding-from-dir

scenario3:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(CHRTOOL_COMPILE_PARAMS) $(SRC_SCENARIO3) --output-dir=$(OUT_PATH)/scenario3 # TODO: --padding-from-dir

premium-disk:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(CHRTOOL_COMPILE_PARAMS) $(SRC_PREMIUM_DISK) --output-dir=$(OUT_PATH)/premium-disk # TODO: --padding-from-dir

recompile: scenario1 scenario2 scenario3 premium-disk
	@echo Done.

$(OUT_PATH)/%.CHR: $(SRC_PATH)/%.SF3CHR
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(CHRTOOL_COMPILE_PARAMS) $< --output=$@

$(OUT_PATH)/%.CHP: $(SRC_PATH)/%.SF3CHP
	$(eval ORIG_FILE=$(shell echo $@ \
		| sed "s/^$(OUT_PATH)\/scenario1\//$(DIR_SCENARIO1_WIN_SED)\//" \
		| sed "s/^$(OUT_PATH)\/scenario2\//$(DIR_SCENARIO2_WIN_SED)\//" \
		| sed "s/^$(OUT_PATH)\/scenario3\//$(DIR_SCENARIO3_WIN_SED)\//" \
		| sed "s/^$(OUT_PATH)\/premium-disk\//$(DIR_PREMIUM_DISK_WIN_SED)\//") \
	)
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $(CHRTOOL_COMPILE_PARAMS) $< --output=$@ --padding-from=$(ORIG_FILE)

clean:
	@echo Removing *.CHR, *.CHP from $(OUT_PATH)...
	@rm -f $(OBJ)
	@echo Done.

update-hash-lookups:
	@$(CHRTOOL) $(CHRTOOL_PARAMS) update-hash-lookups --replace
	@echo Done.

depends:
	@echo "Building Scenario 1 depends..."
	@$(CHRTOOL) $(CHRTOOL_PARAMS) depends $(SRC_SCENARIO1) | sort > depends.txt
	@echo "Building Scenario 2 depends..."
	@$(CHRTOOL) $(CHRTOOL_PARAMS) depends $(SRC_SCENARIO2) | sort >> depends.txt
	@echo "Building Scenario 3 depends..."
	@$(CHRTOOL) $(CHRTOOL_PARAMS) depends $(SRC_SCENARIO3) | sort >> depends.txt
	@echo "Building Premium Disk depends..."
	@$(CHRTOOL) $(CHRTOOL_PARAMS) depends $(SRC_PREMIUM_DISK) | sort >> depends.txt
	@$(eval FIRST_LINE := $(shell grep -n -m 1 "^# DEPENDS UNDER THIS LINE" Makefile | sed 's/\([0-9]*\).*/\1/'))
	@head -n $(FIRST_LINE) Makefile > Makefile.2
	@cat depends.txt | tr -d '\r' | sed "s/\.\///g" | sed "s/^${SRC_PATH}/${OUT_PATH}/g" >> Makefile.2
	@rm depends.txt
	@mv Makefile.2 Makefile

# DEPENDS UNDER THIS LINE
