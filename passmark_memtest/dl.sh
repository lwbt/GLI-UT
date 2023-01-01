#!/bin/bash

wget "https://www.memtest86.com/downloads/memtest86-usb.zip"

# Extraction level 1.
7z e "memtest86-usb.zip" -otmp1

# Extraction level 2.
7z e "tmp1/memtest86-usb.img" -otmp2

# The files are quite big, so lets remove them early
rm -Rv "tmp1/"

# Extraction level 3.
7z e "tmp2/EFI System Partition.img" -oresult

# We can remove results from level 2.
rm -Rv "tmp2/"

# Remove unnecessary folders.
rmdir -v "result/"{"BOOT","EFI","help"}

# Convert from RTF to TXT with LibreOffice, the document was written in
# OpenOffice, so that should be fine. 
soffice --headless --convert-to txt:Text "result/license.rtf" --outdir "result/"

# License file as been converted to more accessible format.
# Manual is too long to convert, product is self-explanatory, file is still
# available.
rm -v "result/"*.{"pdf","rtf"}
