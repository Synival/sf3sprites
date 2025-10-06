CHRTOOL = ./chrtool.exe
CHRTOOL_PARAMS = --sprite-dir=resources/sprites --spritesheet-dir=resources/spritesheets --frame-hash-lookups-file=resources/FrameHashLookups.json

SRC_PATH = src
OUT_PATH = output

SRC = $(sort $(shell find ./$(SRC_PATH) -type f -iname "*.sf3chr" -o -iname "*.sf3chp"))
OBJ = $(shell echo " $(SRC) " | sed "s/ .\/$(SRC_PATH)\// .\/$(OUT_PATH)\//g" | sed "s/\.SF3CHR /.CHR /Ig" | sed "s/\.SF3CHP /.CHP /Ig")

all: $(OBJ)
	@echo Done.

$(OUT_PATH)/%.CHR: $(SRC_PATH)/%.SF3CHR
	$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@

$(OUT_PATH)/%.CHP: $(SRC_PATH)/%.SF3CHP
	$(CHRTOOL) $(CHRTOOL_PARAMS) compile $< --output=$@

clean:
	@echo Removing *.CHR, *.CHP from $(OUT_PATH)...
	@rm -f $(OBJ)
	@echo Done.
