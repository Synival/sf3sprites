# sf3sprites

**Shining Force III Sprite Compilation Pipeline**

**NOTE: This has only been tested and run in Windows using the Linux subsystem. It probably only works there!**

Before compiling:

1. Copy files from each disc desirable to the `game-files/<disc>` folder
2. Update SF3 disc directories in `fetch-resources.sh` 
3. Run `fetch-resources.sh`

To compile:

1. `make`

All `.CHR` and `.CHP` files should be written to the `output` folder.
