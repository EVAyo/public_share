A tool to convert Gameloft pig model file to fbx.

Download from https://forum.xentax.com/viewtopic.php?f=16&t=17591

# Usage
- Drag and drop one or multiple pig files onto the exe; Or:
- Put all files to folder A8Tool and run batch.bat

# About Textures
- In the attachment, there're 3 respective BMS scripts for each platform in separate folders. For Win32, just run QuickBMS with BinUnpacker.bms, and select any .bin files to
unpack the archives. But make sure to keep the .bin and their .hdr files in the same folder.
- Textures from iOS version needs the same decompressor for Android.
- To decompress the resulting .tga textures, use the decompressor in their corresponding folder.

# Note
- You'll need the lastest version of QuickBMS to get those scripts to work.
- To load ASTC-compressed pvr images in PVRTexTool, you'll need to download astcenc.exe, place the corresponding executables in your preferred location, then place the location in the environment variable PATH.