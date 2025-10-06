# sf3sprites

**Shining Force III Sprite Compilation Pipeline**

**NOTE: This has only been tested and run in Windows using the Linux subsystem. It probably only works there!**

Before compiling:

1. Update SF3 disc directories in `fetch-resources.sh` 
2. Run `fetch-resources.sh`

**NOTE: `fetch-resouces.sh` is set up to extract all the resources in one go. You'll have to do some editing if you want to extract them one disc at a time, but it's not too bad.**

To compile:

1. `make`

All `.CHR` and `.CHP` files should be written to the `output` folder.
