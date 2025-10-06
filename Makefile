# Settings
# --------

# Uncomment this to use the junk data in CHP files instead of 0's.
# This is useful for producing DFRs.
# (DIR_*_WIN paths below must be set properly)
#RESPECT_JUNK_PADDING=1

# Paths to original files
DIR_SCENARIO1_WIN="D:"
DIR_SCENARIO2_WIN="E:"
DIR_SCENARIO3_WIN="F:"
DIR_PREMIUM_DISK_WIN="G:"

# ------------------------------------------------

CHRTOOL = ./chrtool.exe
CHRTOOL_PARAMS = --sprite-dir=resources/sprites --spritesheet-dir=resources/spritesheets --frame-hash-lookups-file=resources/FrameHashLookups.json

SRC_PATH = src
OUT_PATH = output

SRC = $(shell find ./$(SRC_PATH)/scenario1 -type f -iname "*.sf3chr" -o -iname "*.sf3chp") \
      $(shell find ./$(SRC_PATH)/scenario2 -type f -iname "*.sf3chr" -o -iname "*.sf3chp") \
      $(shell find ./$(SRC_PATH)/scenario3 -type f -iname "*.sf3chr" -o -iname "*.sf3chp") \
      $(shell find ./$(SRC_PATH)/premium-disk -type f -iname "*.sf3chr" -o -iname "*.sf3chp")

OBJ = $(shell echo " $(SRC) " | sed "s/ .\/$(SRC_PATH)\// .\/$(OUT_PATH)\//g" | sed "s/\.SF3CHR /.CHR /Ig" | sed "s/\.SF3CHP /.CHP /Ig")

all: $(OBJ)
	@echo Done.

$(OUT_PATH)/%.CHR: $(SRC_PATH)/%.SF3CHR
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@

ifdef RESPECT_JUNK_PADDING

$(OUT_PATH)/%.CHP: $(SRC_PATH)/%.SF3CHP
	$(eval ORIG_FILE=$(shell echo $@ \
		| sed "s/^$(OUT_PATH)\/scenario1\//$(DIR_SCENARIO1_WIN)\//" \
		| sed "s/^$(OUT_PATH)\/scenario2\//$(DIR_SCENARIO2_WIN)\//" \
		| sed "s/^$(OUT_PATH)\/scenario3\//$(DIR_SCENARIO3_WIN)\//" \
		| sed "s/^$(OUT_PATH)\/premium-disk\//$(DIR_PREMIUM_DISK_WIN)\//""") \
	)
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@ --padding-from=$(ORIG_FILE)

else

$(OUT_PATH)/%.CHP: $(SRC_PATH)/%.SF3CHP
	@$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@

endif

clean:
	@echo Removing *.CHR, *.CHP from $(OUT_PATH)...
	@rm -f $(OBJ)
	@echo Done.
